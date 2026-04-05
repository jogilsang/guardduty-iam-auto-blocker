# GuardDuty Auto-Patcher

Immediate threat isolation solution - Automatically blocks and isolates IAM permissions when GuardDuty detects threats.

[한국어 문서](./README_KR.md)

![](./architecture_guardduty_etc.png)

## Features

1. **IAM Blocking**: Automatically attaches Deny-All inline policy
2. **Tagging**: Automatically adds detection time and Finding Type tags
3. **Access Key Deactivation**: Immediately deactivates related access keys
4. **Filtering**: Monitor only specific Finding Types
5. **Exclusion Lists**: Exclude specific IAM Users or Roles from remediation
6. **Log Storage**: Saves action results in CSV format to S3

## Prerequisites

- AWS Account with GuardDuty enabled
- AWS CLI configured
- Sufficient IAM permissions for deployment
- Python 3.12+ (for Lambda runtime)

## Deployment

### 1. Configure Settings

Edit the `config.env` file:

```bash
# Monitor specific Finding Types (comma-separated, no spaces)
FINDING_TYPES="UnauthorizedAccess:IAMUser/InstanceCredentialExfiltration.OutsideAWS,Policy:IAMUser/RootCredentialUsage"

# Or monitor all findings (empty value)
FINDING_TYPES=""

# S3 bucket name (auto-generated if empty)
S3_BUCKET_NAME=""
# Or specify a name
S3_BUCKET_NAME="my-company-guardduty-logs"

# Exclude specific IAM Users or Roles from remediation
EXCLUDED_USERS="admin-user,break-glass-admin"
EXCLUDED_ROLES="OrganizationAccountAccessRole"
```

**See `finding_types.md` for the complete list of Finding Types.**

### 2. Deploy

```bash
# Profile and region are required arguments
./deploy.sh <AWS_PROFILE> <AWS_REGION>

# Examples
./deploy.sh my-profile ap-northeast-2
./deploy.sh production us-east-1
```

## Architecture

- **Lambda Function**: `GuardDutyAutoPatcher`
- **EventBridge Rule**: `GuardDutyAutoPatcherRule`
- **IAM Role**: `GuardDutyAutoPatcherRole`
- **S3 Bucket**: Configured or auto-generated name

## How It Works

1. GuardDuty detects a threat
2. EventBridge forwards the Finding to Lambda
3. Lambda automatically:
   - Attaches Deny-All policy to IAM User
   - Adds detection information as tags
   - Deactivates access keys
   - Saves action results to S3

## Log Access

CSV files are available at `guardduty-actions/YYYY-MM-DD/` in the S3 bucket

## Important Notes

- **GuardDuty must be enabled**
- **Deployment account requires sufficient IAM permissions**
- **Quarantined users must be manually restored**
- **SNS notification setup is manual** (Add SNS Target to EventBridge Rule)

## SNS Notification Setup (Optional)

Configure manually in AWS Console after deployment:

1. Go to EventBridge Console → Rules → Select `GuardDutyAutoPatcherRule`
2. Click "Add target" in Targets section
3. Select or create SNS topic
4. Subscribe email addresses for notifications

## Project Structure

```
.
├── lambda_function.py      # Lambda handler code
├── deploy.sh              # Deployment script
├── config.env             # Configuration file
├── finding_types.md       # Complete Finding Types reference
├── requirements.md        # Project requirements
├── README.md              # This file (English)
├── README_KR.md           # Korean documentation
└── .gitignore            # Git ignore rules
```

## Security

This solution follows Zero Trust principles:
- No credentials hardcoded
- Least privilege IAM policies
- S3 bucket with public access blocked
- All actions logged for audit
