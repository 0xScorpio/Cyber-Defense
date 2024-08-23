Kerberoasting is a common post-exploitation attack that extracts service account credential hashes from Active Directory for offline cracking. 
Kerberoasting attacks leverage the Windows Kerberos protocol to obtain packets sent from the KDC (Key Distribution Center) which are encrypted using a specific user's NTLM hash. More specifically, the attack exploits the Kerberos TGS mechanism to obtain a TGS encrypted with the NTLM hash of a user account, with the objective of cracking the user's hash to reveal its cleartext password. 
TGS packets can be cracked offline using brute-force or dictionary attacks to reveal the SPN user's cleartext password.

## Impact
Any domain user can request a TGT for a domain service, even a user that has no privileges over the requested service. A TGT (Ticket Granting Ticket) is used to issue a TGS (Ticket Granting Server) for a specific domain service (such as an SQL server, web application, and the likes) from the KDC (Key Distribution Center). The TGS lists the requesting user's privileges over the requested domain service. The catch is that a TGS is granted even if the user has absolutely no privileges over the requested service (for example, a domain guest user requesting access to an SQL server).
The TGS is encrypted using the service account's NTLM hash, and therefore it cannot be edited.
Here's where things get problematic. Typically, a service account is a computer account with a highly complex and long password. However, a service account can also be a user account, which tends to simplify integration with other components. Furthermore, service accounts are often overprovisioned. For easier configuration, IT professionals tend to set the service account's user in a sub-group of Domain Admins, which is extremely insecure. More often than not, this user account will have a password that is shorter, less complex, and more amenable to cracking than that of a computer account.

## Recommendations
	• Avoid configuring service accounts as user accounts, unless necessary.
	• Grant permissions to users & groups only as necessary for their tasks.
	• Enforce proper password complexity requirements. The weakest link are predictable, easily-guessed passwords.
	
## Technical Enforcement
	• https://owasp.org/www-pdf-archive/OWASP_Frankfurt_-44_Kerberoasting.pdf
https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/register-a-service-principal-name-for-kerberos-connections?view=sql-server-ver15
Enforce password complexity in the domain environment.
