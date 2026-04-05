import json
import boto3
import os
from datetime import datetime
from io import StringIO

iam = boto3.client('iam')
s3 = boto3.client('s3')

DENY_POLICY_NAME = 'GuardDutyAutoQuarantine'
DENY_POLICY = {
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Deny",
        "Action": "*",
        "Resource": "*"
    }]
}

def lambda_handler(event, context):
    results = []
    timestamp = datetime.utcnow().isoformat()
    
    detail = event.get('detail', {})
    finding_type = detail.get('type', 'Unknown')
    severity = detail.get('severity', 0)
    
    resource = detail.get('resource', {})
    access_key_details = resource.get('accessKeyDetails', {})
    principal_id = access_key_details.get('principalId', '')
    user_name = access_key_details.get('userName', '')
    access_key_id = access_key_details.get('accessKeyId', '')
    
    if not user_name:
        return {'statusCode': 200, 'body': 'No IAM user found'}
    
    # Check exclusion lists
    excluded_users = os.environ.get('EXCLUDED_USERS', '').split(',')
    excluded_users = [u.strip() for u in excluded_users if u.strip()]
    
    excluded_roles = os.environ.get('EXCLUDED_ROLES', '').split(',')
    excluded_roles = [r.strip() for r in excluded_roles if r.strip()]
    
    if user_name in excluded_users:
        return {'statusCode': 200, 'body': f'User {user_name} is excluded from remediation'}
    
    # Check if principal is a role
    if principal_id.startswith('AROA'):
        role_name = user_name.split('/')[-1] if '/' in user_name else user_name
        if role_name in excluded_roles:
            return {'statusCode': 200, 'body': f'Role {role_name} is excluded from remediation'}
    
    result = {
        'timestamp': timestamp,
        'finding_type': finding_type,
        'severity': severity,
        'principal_id': principal_id,
        'user_name': user_name,
        'access_key_id': access_key_id,
        'actions': []
    }
    
    # 1. Deny-All policy attachment
    try:
        iam.put_user_policy(
            UserName=user_name,
            PolicyName=DENY_POLICY_NAME,
            PolicyDocument=json.dumps(DENY_POLICY)
        )
        result['actions'].append('DenyPolicyAttached')
    except Exception as e:
        result['actions'].append(f'DenyPolicyFailed:{str(e)}')
    
    # 2. Add tags
    try:
        user_arn = f"arn:aws:iam::{context.invoked_function_arn.split(':')[4]}:user/{user_name}"
        iam.tag_user(
            UserName=user_name,
            Tags=[
                {'Key': 'GuardDutyQuarantined', 'Value': timestamp},
                {'Key': 'GuardDutyFindingType', 'Value': finding_type[:256]}
            ]
        )
        result['actions'].append('TagsAdded')
    except Exception as e:
        result['actions'].append(f'TagsFailed:{str(e)}')
    
    # 3. Deactivate access key
    if access_key_id:
        try:
            iam.update_access_key(
                UserName=user_name,
                AccessKeyId=access_key_id,
                Status='Inactive'
            )
            result['actions'].append('AccessKeyDeactivated')
        except Exception as e:
            result['actions'].append(f'AccessKeyFailed:{str(e)}')
    
    results.append(result)
    
    # 4. Save to S3 as CSV
    bucket = os.environ.get('S3_BUCKET')
    if bucket:
        try:
            csv_content = StringIO()
            csv_content.write('Timestamp,FindingType,Severity,PrincipalId,UserName,AccessKeyId,Actions\n')
            for r in results:
                csv_content.write(f"{r['timestamp']},{r['finding_type']},{r['severity']},{r['principal_id']},{r['user_name']},{r['access_key_id']},\"{';'.join(r['actions'])}\"\n")
            
            key = f"guardduty-actions/{timestamp.split('T')[0]}/{timestamp}.csv"
            s3.put_object(Bucket=bucket, Key=key, Body=csv_content.getvalue())
        except Exception as e:
            print(f"S3 upload failed: {e}")
    
    return {'statusCode': 200, 'body': json.dumps(results)}
