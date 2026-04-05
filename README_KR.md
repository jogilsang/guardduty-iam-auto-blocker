# GuardDuty Auto-Patcher

즉각적 위협 격리 솔루션 - GuardDuty 탐지 시 자동으로 IAM 권한을 차단하고 격리합니다.

![](./architecture_guardduty_etc.png)

## 기능

1. **IAM 차단**: Deny-All 인라인 정책 자동 부착
2. **태깅**: 탐지 시간 및 Finding Type 자동 태그 추가
3. **액세스 키 비활성화**: 관련 액세스 키 즉시 비활성화
4. **필터링 가능**: 특정 Finding Type만 모니터링 가능
5. **예외 처리**: 특정 IAM User 또는 Role을 자동 조치에서 제외
6. **로그 저장**: S3에 CSV 형태로 작업 결과 저장

## 배포 방법

### 1. 설정 파일 수정

`config.env` 파일을 열어 필요한 설정을 수정합니다:

```bash
# 특정 Finding Type만 모니터링 (쉼표로 구분, 공백 없이)
FINDING_TYPES="UnauthorizedAccess:IAMUser/InstanceCredentialExfiltration.OutsideAWS,Policy:IAMUser/RootCredentialUsage"

# 또는 모든 Finding 모니터링 (빈 값)
FINDING_TYPES=""

# S3 버킷 이름 (빈 값이면 자동 생성)
S3_BUCKET_NAME=""
# 또는 특정 이름 지정
S3_BUCKET_NAME="my-company-guardduty-logs"

# 자동 조치에서 제외할 특정 IAM User 또는 Role 지정
EXCLUDED_USERS="admin-user,break-glass-admin"
EXCLUDED_ROLES="OrganizationAccountAccessRole"
```

**전체 Finding Type 목록은 `finding_types.md` 파일을 참조하세요.**

### 2. 배포 실행

```bash
# 프로필과 리전은 필수 인자입니다
./deploy.sh <AWS_PROFILE> <AWS_REGION>

# 예시
./deploy.sh my-profile ap-northeast-2
./deploy.sh production us-east-1
```

## 구성 요소

- **Lambda Function**: `GuardDutyAutoPatcher`
- **EventBridge Rule**: `GuardDutyAutoPatcherRule`
- **IAM Role**: `GuardDutyAutoPatcherRole`
- **S3 Bucket**: 설정한 버킷 이름 또는 자동 생성된 이름

## 작동 방식

1. GuardDuty가 위협 탐지
2. EventBridge가 Finding을 Lambda로 전달
3. Lambda가 자동으로:
   - IAM User에 Deny-All 정책 부착
   - 탐지 정보를 태그로 추가
   - 액세스 키 비활성화
   - S3에 작업 결과 저장

## 로그 확인

S3 버킷의 `guardduty-actions/YYYY-MM-DD/` 경로에서 CSV 파일 확인 가능

## 주의사항

- **GuardDuty가 활성화되어 있어야 합니다**
- **배포 계정에 충분한 IAM 권한이 필요합니다**
- **격리된 사용자는 수동으로 복구해야 합니다**
- **SNS 알림 연결은 별도로 설정해야 합니다** (EventBridge Rule에 SNS Target 추가)

## SNS 알림 설정 (선택사항)

배포 후 AWS Console에서 수동으로 설정:

1. EventBridge Console → Rules → `GuardDutyAutoPatcherRule` 선택
2. Targets 섹션에서 "Add target" 클릭
3. SNS topic 선택 또는 생성
4. 알림을 받을 이메일 주소 구독 설정
