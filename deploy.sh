#!/bin/bash
set -e

if [ $# -lt 2 ]; then
    echo "Usage: $0 <AWS_PROFILE> <AWS_REGION>"
    echo "Example: $0 my-profile ap-northeast-2"
    exit 1
fi

PROFILE=$1
REGION=$2

echo "=== GuardDuty Auto-Patcher Deployment ==="
echo "Profile: $PROFILE"
echo "Region: $REGION"

source config.env

ACCOUNT_ID=$(aws sts get-caller-identity --profile $PROFILE --query Account --output text)
LAMBDA_NAME="GuardDutyAutoPatcher"
ROLE_NAME="GuardDutyAutoPatcherRole"
RULE_NAME="GuardDutyAutoPatcherRule"

# S3 버킷 이름 설정 (빈 값이면 난수 생성)
if [ -z "$S3_BUCKET_NAME" ]; then
    RANDOM_SUFFIX=$(openssl rand -hex 4)
    S3_BUCKET_NAME="guardduty-auto-patcher-logs-${RANDOM_SUFFIX}"
    echo "Generated S3 bucket name: $S3_BUCKET_NAME"
fi

echo "Account ID: $ACCOUNT_ID"

# S3 버킷 생성
echo "Creating S3 bucket..."
if aws s3 ls s3://$S3_BUCKET_NAME --profile $PROFILE --region $REGION 2>/dev/null; then
    echo "Bucket already exists"
else
    if [ "$REGION" = "us-east-1" ]; then
        aws s3 mb s3://$S3_BUCKET_NAME --profile $PROFILE --region $REGION
    else
        aws s3 mb s3://$S3_BUCKET_NAME --profile $PROFILE --region $REGION --create-bucket-configuration LocationConstraint=$REGION
    fi
    aws s3api put-public-access-block --bucket $S3_BUCKET_NAME --profile $PROFILE --region $REGION \
        --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
fi

# IAM Role 생성
echo "Creating IAM role..."
TRUST_POLICY=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {"Service": "lambda.amazonaws.com"},
    "Action": "sts:AssumeRole"
  }]
}
EOF
)

if aws iam get-role --role-name $ROLE_NAME --profile $PROFILE 2>/dev/null; then
    echo "Role already exists"
else
    aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document "$TRUST_POLICY" --profile $PROFILE
    sleep 5
fi

# IAM Policy 생성 및 부착
POLICY_DOC=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:$REGION:$ACCOUNT_ID:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:PutUserPolicy",
        "iam:TagUser",
        "iam:UpdateAccessKey",
        "iam:ListAccessKeys"
      ],
      "Resource": "arn:aws:iam::$ACCOUNT_ID:user/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::$S3_BUCKET_NAME/*"
    }
  ]
}
EOF
)

aws iam put-role-policy --role-name $ROLE_NAME --policy-name GuardDutyAutoPatcherPolicy --policy-document "$POLICY_DOC" --profile $PROFILE

# Lambda 함수 패키징
echo "Packaging Lambda function..."
zip -q lambda.zip lambda_function.py

# Lambda 함수 생성/업데이트
echo "Deploying Lambda function..."
if aws lambda get-function --function-name $LAMBDA_NAME --profile $PROFILE --region $REGION 2>/dev/null; then
    aws lambda update-function-code --function-name $LAMBDA_NAME --zip-file fileb://lambda.zip --profile $PROFILE --region $REGION
    aws lambda update-function-configuration --function-name $LAMBDA_NAME \
        --environment "Variables={S3_BUCKET=$S3_BUCKET_NAME,EXCLUDED_USERS=$EXCLUDED_USERS,EXCLUDED_ROLES=$EXCLUDED_ROLES}" \
        --profile $PROFILE --region $REGION
else
    aws lambda create-function --function-name $LAMBDA_NAME \
        --runtime python3.12 \
        --role arn:aws:iam::$ACCOUNT_ID:role/$ROLE_NAME \
        --handler lambda_function.lambda_handler \
        --zip-file fileb://lambda.zip \
        --timeout 60 \
        --environment "Variables={S3_BUCKET=$S3_BUCKET_NAME,EXCLUDED_USERS=$EXCLUDED_USERS,EXCLUDED_ROLES=$EXCLUDED_ROLES}" \
        --profile $PROFILE --region $REGION
fi

LAMBDA_ARN=$(aws lambda get-function --function-name $LAMBDA_NAME --profile $PROFILE --region $REGION --query Configuration.FunctionArn --output text)

# EventBridge Rule 생성
echo "Creating EventBridge rule..."
if [ -z "$FINDING_TYPES" ]; then
    EVENT_PATTERN=$(cat <<EOF
{
  "source": ["aws.guardduty"],
  "detail-type": ["GuardDuty Finding"]
}
EOF
)
else
    IFS=',' read -ra TYPES <<< "$FINDING_TYPES"
    TYPES_JSON=$(printf ',"%s"' "${TYPES[@]}")
    TYPES_JSON="[${TYPES_JSON:1}]"
    EVENT_PATTERN=$(cat <<EOF
{
  "source": ["aws.guardduty"],
  "detail-type": ["GuardDuty Finding"],
  "detail": {
    "type": $TYPES_JSON
  }
}
EOF
)
fi

aws events put-rule --name $RULE_NAME --event-pattern "$EVENT_PATTERN" --state ENABLED --profile $PROFILE --region $REGION

# Lambda 권한 추가
aws lambda add-permission --function-name $LAMBDA_NAME \
    --statement-id GuardDutyEventBridge \
    --action lambda:InvokeFunction \
    --principal events.amazonaws.com \
    --source-arn arn:aws:events:$REGION:$ACCOUNT_ID:rule/$RULE_NAME \
    --profile $PROFILE --region $REGION 2>/dev/null || echo "Permission already exists"

# EventBridge Target 추가
aws events put-targets --rule $RULE_NAME --targets "Id=1,Arn=$LAMBDA_ARN" --profile $PROFILE --region $REGION

# 정리
rm lambda.zip

echo ""
echo "=== Deployment Complete ==="
echo "Lambda Function: $LAMBDA_NAME"
echo "EventBridge Rule: $RULE_NAME"
echo "S3 Bucket: $S3_BUCKET_NAME"
echo "Monitored Finding Types: ${FINDING_TYPES:-ALL}"
echo "Excluded Users: ${EXCLUDED_USERS:-NONE}"
echo "Excluded Roles: ${EXCLUDED_ROLES:-NONE}"
