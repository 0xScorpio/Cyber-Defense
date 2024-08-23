Workstations and servers in Microsoft environments often have a common, hard-coded local administrator account. The danger is that identical local admin credentials will be used throughout the environment because the devices are either set up using a fixed installation procedure that includes specific local administrator credentials or because devices are being generated using a master image. 
If, in fact, devices in an environment share the same local admin credentials, this can become a critical security issue should the credentials become compromised or known to attackers, who could then completely compromise numerous, or even all systems via their local administrator accounts.
Microsoft offers the Local Administrator Password Solution (LAPS) to help mitigate this common problem. LAPS is a GPO client-side extension (CSE) that uses Access Control Lists (ACLs) to protect passwords in Active Directory and automatically generate and update the local admin passwords on managed devices. Proper implementation of LAPS can help to contain the damage if a single local admin password is compromised by ensuring that each local administrator password is used only once in the environment.
## Insights
LAPS can expand the attack surface if implemented insecurely. 
Microsoft LAPS randomly generates passwords for all local admin accounts and stores the value of each password in cleartext in an Active Directory object within each Active Directory Computer Account. The caveat is that LAPS does not regulate access to the LDAP object containing the local administrator password, and if misconfigured it could become available to unprivileged users.
## Impact
If the LDAP object ms-MCS-AdmPwd becomes accessible to unprivileged users due to a misconfiguration, attackers can easily extract the local administrator password for all Computer Objects managed by LAPS. The fallout could be similar to an attacker obtaining the credentials for a domain administrator.

![image](https://github.com/user-attachments/assets/e428d7ad-2d83-45c3-907a-e97a4616912c)

The following PowerShell command can be used to enumerate the domain groups with access to the ms-MCS-AdmPwd object:
`` Find-AdmPwdExtendedRights -Identity 'OU=Computers,DC=MyDomain,DC=local'| % {$_.ExtendedRightHolders} ``

![image](https://github.com/user-attachments/assets/fe8330ed-6d96-438b-8c36-e06224fc8cba)

## Recommendations
Members of the following have access to the ms-MCS-AdmPwd object by default:
	• Domain Admins
	• System 
	• All extended rights
Should any extraneous groups have access, this can be pruned by doing the following:
	1. Open Active Directory Users and Computers as an account with Domain Admin rights
	2. Right-click the relevant Organizational Unit (OU) and select Properties
	3. Select the Security tab
	4. Select Advanced
	5. Modify the permissions:
		1. Select the user or group to modify permissions for
		2. Select Edit
		3. Remove All extended rights (uncheck the box) 
  ![image](https://github.com/user-attachments/assets/4e9a153b-490f-4e84-9a13-27ded1abacaa)

