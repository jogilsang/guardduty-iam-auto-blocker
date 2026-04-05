# GuardDuty Finding Types Reference

이 문서는 AWS GuardDuty가 탐지할 수 있는 모든 Finding Type을 정리한 참조 문서입니다.
config.env 파일에서 FINDING_TYPES 설정 시 참고하세요.

## IAM Finding Types

### Credential Access
- CredentialAccess:IAMUser/AnomalousBehavior
- CredentialAccess:IAMUser/CompromisedCredentials

### Defense Evasion
- DefenseEvasion:IAMUser/AnomalousBehavior
- DefenseEvasion:IAMUser/BedrockLoggingDisabled

### Discovery
- Discovery:IAMUser/AnomalousBehavior

### Exfiltration
- Exfiltration:IAMUser/AnomalousBehavior

### Impact
- Impact:IAMUser/AnomalousBehavior

### Initial Access
- InitialAccess:IAMUser/AnomalousBehavior

### Penetration Testing
- PenTest:IAMUser/KaliLinux
- PenTest:IAMUser/ParrotLinux
- PenTest:IAMUser/PentooLinux

### Persistence
- Persistence:IAMUser/AnomalousBehavior

### Policy
- Policy:IAMUser/RootCredentialUsage
- Policy:IAMUser/ShortTermRootCredentialUsage

### Privilege Escalation
- PrivilegeEscalation:IAMUser/AnomalousBehavior

### Reconnaissance
- Recon:IAMUser/MaliciousIPCaller
- Recon:IAMUser/MaliciousIPCaller.Custom
- Recon:IAMUser/TorIPCaller

### Stealth
- Stealth:IAMUser/CloudTrailLoggingDisabled
- Stealth:IAMUser/PasswordPolicyChange

### Unauthorized Access
- UnauthorizedAccess:IAMUser/ConsoleLoginSuccess.B
- UnauthorizedAccess:IAMUser/InstanceCredentialExfiltration.InsideAWS
- UnauthorizedAccess:IAMUser/InstanceCredentialExfiltration.OutsideAWS
- UnauthorizedAccess:IAMUser/MaliciousIPCaller
- UnauthorizedAccess:IAMUser/MaliciousIPCaller.Custom
- UnauthorizedAccess:IAMUser/ResourceCredentialExfiltration.OutsideAWS
- UnauthorizedAccess:IAMUser/TorIPCaller

## S3 Finding Types

### Discovery
- Discovery:S3/AnomalousBehavior
- Discovery:S3/MaliciousIPCaller
- Discovery:S3/MaliciousIPCaller.Custom
- Discovery:S3/TorIPCaller

### Exfiltration
- Exfiltration:S3/AnomalousBehavior
- Exfiltration:S3/MaliciousIPCaller

### Impact
- Impact:S3/AnomalousBehavior.Delete
- Impact:S3/AnomalousBehavior.Permission
- Impact:S3/AnomalousBehavior.Write
- Impact:S3/MaliciousIPCaller

### Penetration Testing
- PenTest:S3/KaliLinux
- PenTest:S3/ParrotLinux
- PenTest:S3/PentooLinux

### Policy
- Policy:S3/AccountBlockPublicAccessDisabled
- Policy:S3/BucketAnonymousAccessGranted
- Policy:S3/BucketBlockPublicAccessDisabled
- Policy:S3/BucketPublicAccessGranted

### Stealth
- Stealth:S3/ServerAccessLoggingDisabled

### Unauthorized Access
- UnauthorizedAccess:S3/MaliciousIPCaller.Custom
- UnauthorizedAccess:S3/TorIPCaller

### Malware Protection
- Object:S3/MaliciousFile

## EC2 Finding Types

### Backdoor
- Backdoor:EC2/C&CActivity.B
- Backdoor:EC2/C&CActivity.B!DNS
- Backdoor:EC2/DenialOfService.Dns
- Backdoor:EC2/DenialOfService.Tcp
- Backdoor:EC2/DenialOfService.Udp
- Backdoor:EC2/DenialOfService.UdpOnTcpPorts
- Backdoor:EC2/DenialOfService.UnusualProtocol
- Backdoor:EC2/Spambot

### Behavior
- Behavior:EC2/NetworkPortUnusual
- Behavior:EC2/TrafficVolumeUnusual

### Cryptocurrency
- CryptoCurrency:EC2/BitcoinTool.B
- CryptoCurrency:EC2/BitcoinTool.B!DNS

### Defense Evasion
- DefenseEvasion:EC2/UnusualDNSResolver
- DefenseEvasion:EC2/UnusualDoHActivity
- DefenseEvasion:EC2/UnusualDoTActivity

### Impact
- Impact:EC2/AbusedDomainRequest.Reputation
- Impact:EC2/BitcoinDomainRequest.Reputation
- Impact:EC2/MaliciousDomainRequest.Custom
- Impact:EC2/MaliciousDomainRequest.Reputation
- Impact:EC2/PortSweep
- Impact:EC2/SuspiciousDomainRequest.Reputation
- Impact:EC2/WinRMBruteForce

### Reconnaissance
- Recon:EC2/PortProbeEMRUnprotectedPort
- Recon:EC2/PortProbeUnprotectedPort
- Recon:EC2/Portscan

### Trojan
- Trojan:EC2/BlackholeTraffic
- Trojan:EC2/BlackholeTraffic!DNS
- Trojan:EC2/DGADomainRequest.B
- Trojan:EC2/DGADomainRequest.C!DNS
- Trojan:EC2/DNSDataExfiltration
- Trojan:EC2/DriveBySourceTraffic!DNS
- Trojan:EC2/DropPoint
- Trojan:EC2/DropPoint!DNS
- Trojan:EC2/PhishingDomainRequest!DNS

### Unauthorized Access
- UnauthorizedAccess:EC2/MaliciousIPCaller.Custom
- UnauthorizedAccess:EC2/MetadataDNSRebind
- UnauthorizedAccess:EC2/RDPBruteForce
- UnauthorizedAccess:EC2/SSHBruteForce
- UnauthorizedAccess:EC2/TorClient
- UnauthorizedAccess:EC2/TorRelay

### Malware Protection
- Execution:EC2/MaliciousFile
- Execution:EC2/SuspiciousFile
- Execution:EC2/MaliciousFile!Snapshot
- Execution:EC2/MaliciousFile!AMI
- Execution:EC2/MaliciousFile!RecoveryPoint

## EKS/Kubernetes Finding Types

### Credential Access
- CredentialAccess:Kubernetes/AnomalousBehavior.SecretsAccessed
- CredentialAccess:Kubernetes/MaliciousIPCaller
- CredentialAccess:Kubernetes/MaliciousIPCaller.Custom
- CredentialAccess:Kubernetes/SuccessfulAnonymousAccess
- CredentialAccess:Kubernetes/TorIPCaller

### Defense Evasion
- DefenseEvasion:Kubernetes/MaliciousIPCaller
- DefenseEvasion:Kubernetes/MaliciousIPCaller.Custom
- DefenseEvasion:Kubernetes/SuccessfulAnonymousAccess
- DefenseEvasion:Kubernetes/TorIPCaller

### Discovery
- Discovery:Kubernetes/AnomalousBehavior.PermissionChecked
- Discovery:Kubernetes/MaliciousIPCaller
- Discovery:Kubernetes/MaliciousIPCaller.Custom
- Discovery:Kubernetes/SuccessfulAnonymousAccess
- Discovery:Kubernetes/TorIPCaller

### Execution
- Execution:Kubernetes/AnomalousBehavior.ExecInPod
- Execution:Kubernetes/AnomalousBehavior.WorkloadDeployed
- Execution:Kubernetes/ExecInKubeSystemPod
- Execution:Kubernetes/MaliciousFile
- Execution:Kubernetes/SuspiciousFile

### Impact
- Impact:Kubernetes/MaliciousIPCaller
- Impact:Kubernetes/MaliciousIPCaller.Custom
- Impact:Kubernetes/SuccessfulAnonymousAccess
- Impact:Kubernetes/TorIPCaller

### Persistence
- Persistence:Kubernetes/AnomalousBehavior.WorkloadDeployed!ContainerWithSensitiveMount
- Persistence:Kubernetes/ContainerWithSensitiveMount
- Persistence:Kubernetes/MaliciousIPCaller
- Persistence:Kubernetes/MaliciousIPCaller.Custom
- Persistence:Kubernetes/SuccessfulAnonymousAccess
- Persistence:Kubernetes/TorIPCaller

### Policy
- Policy:Kubernetes/AdminAccessToDefaultServiceAccount
- Policy:Kubernetes/AnonymousAccessGranted
- Policy:Kubernetes/ExposedDashboard
- Policy:Kubernetes/KubeflowDashboardExposed

### Privilege Escalation
- PrivilegeEscalation:Kubernetes/AnomalousBehavior.RoleBindingCreated
- PrivilegeEscalation:Kubernetes/AnomalousBehavior.RoleCreated
- PrivilegeEscalation:Kubernetes/AnomalousBehavior.WorkloadDeployed!PrivilegedContainer
- PrivilegeEscalation:Kubernetes/PrivilegedContainer

## ECS/Container Finding Types

### Execution
- Execution:Container/MaliciousFile
- Execution:Container/SuspiciousFile
- Execution:ECS/MaliciousFile
- Execution:ECS/SuspiciousFile

## Lambda Finding Types

### Backdoor
- Backdoor:Lambda/C&CActivity.B

### Cryptocurrency
- CryptoCurrency:Lambda/BitcoinTool.B

### Trojan
- Trojan:Lambda/BlackholeTraffic
- Trojan:Lambda/DropPoint

### Unauthorized Access
- UnauthorizedAccess:Lambda/MaliciousIPCaller.Custom
- UnauthorizedAccess:Lambda/TorClient
- UnauthorizedAccess:Lambda/TorRelay

## RDS Finding Types

### Credential Access
- CredentialAccess:RDS/AnomalousBehavior.FailedLogin
- CredentialAccess:RDS/AnomalousBehavior.SuccessfulBruteForce
- CredentialAccess:RDS/AnomalousBehavior.SuccessfulLogin
- CredentialAccess:RDS/MaliciousIPCaller.FailedLogin
- CredentialAccess:RDS/MaliciousIPCaller.SuccessfulLogin
- CredentialAccess:RDS/TorIPCaller.FailedLogin
- CredentialAccess:RDS/TorIPCaller.SuccessfulLogin

### Discovery
- Discovery:RDS/MaliciousIPCaller
- Discovery:RDS/TorIPCaller

## Runtime Monitoring Finding Types

### Backdoor
- Backdoor:Runtime/C&CActivity.B
- Backdoor:Runtime/C&CActivity.B!DNS

### Cryptocurrency
- CryptoCurrency:Runtime/BitcoinTool.B
- CryptoCurrency:Runtime/BitcoinTool.B!DNS

### Defense Evasion
- DefenseEvasion:Runtime/FilelessExecution
- DefenseEvasion:Runtime/KernelModuleLoaded
- DefenseEvasion:Runtime/ProcessInjection.Proc
- DefenseEvasion:Runtime/ProcessInjection.Ptrace
- DefenseEvasion:Runtime/ProcessInjection.VirtualMemoryWrite
- DefenseEvasion:Runtime/PtraceAntiDebugging
- DefenseEvasion:Runtime/SuspiciousCommand

### Discovery
- Discovery:Runtime/SuspiciousCommand

### Execution
- Execution:Runtime/MaliciousFileExecuted
- Execution:Runtime/NewBinaryExecuted
- Execution:Runtime/NewLibraryLoaded
- Execution:Runtime/ReverseShell
- Execution:Runtime/SuspiciousCommand
- Execution:Runtime/SuspiciousShellCreated
- Execution:Runtime/SuspiciousTool

### Impact
- Impact:Runtime/AbusedDomainRequest.Reputation
- Impact:Runtime/BitcoinDomainRequest.Reputation
- Impact:Runtime/CryptoMinerExecuted
- Impact:Runtime/MaliciousDomainRequest.Reputation
- Impact:Runtime/SuspiciousDomainRequest.Reputation

### Persistence
- Persistence:Runtime/SuspiciousCommand

### Privilege Escalation
- PrivilegeEscalation:Runtime/CGroupsReleaseAgentModified
- PrivilegeEscalation:Runtime/ContainerMountsHostDirectory
- PrivilegeEscalation:Runtime/DockerSocketAccessed
- PrivilegeEscalation:Runtime/ElevationToRoot
- PrivilegeEscalation:Runtime/RuncContainerEscape
- PrivilegeEscalation:Runtime/SuspiciousCommand
- PrivilegeEscalation:Runtime/UserfaultfdUsage

### Trojan
- Trojan:Runtime/BlackholeTraffic
- Trojan:Runtime/BlackholeTraffic!DNS
- Trojan:Runtime/DGADomainRequest.C!DNS
- Trojan:Runtime/DriveBySourceTraffic!DNS
- Trojan:Runtime/DropPoint
- Trojan:Runtime/DropPoint!DNS
- Trojan:Runtime/PhishingDomainRequest!DNS

### Unauthorized Access
- UnauthorizedAccess:Runtime/MetadataDNSRebind
- UnauthorizedAccess:Runtime/TorClient
- UnauthorizedAccess:Runtime/TorRelay

## Attack Sequence Finding Types

- AttackSequence:EC2/CompromisedInstanceGroup
- AttackSequence:ECS/CompromisedCluster
- AttackSequence:EKS/CompromisedCluster
- AttackSequence:IAM/CompromisedCredentials
- AttackSequence:S3/CompromisedData

## 사용 예시

### 모든 IAM 관련 위협 모니터링
```bash
FINDING_TYPES="UnauthorizedAccess:IAMUser/InstanceCredentialExfiltration.OutsideAWS,Policy:IAMUser/RootCredentialUsage,Stealth:IAMUser/CloudTrailLoggingDisabled"
```

### 특정 고위험 위협만 모니터링
```bash
FINDING_TYPES="UnauthorizedAccess:IAMUser/InstanceCredentialExfiltration.OutsideAWS,CredentialAccess:IAMUser/CompromisedCredentials,AttackSequence:IAM/CompromisedCredentials"
```

### 모든 Finding Type 모니터링
```bash
FINDING_TYPES=""
```

## 참고
- 각 Finding Type은 쉼표(,)로 구분합니다
- 공백 없이 정확히 입력해야 합니다
- 빈 값("")으로 설정하면 모든 GuardDuty Finding을 모니터링합니다
- 자세한 내용은 AWS 공식 문서를 참조하세요: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_finding-types-active.html
