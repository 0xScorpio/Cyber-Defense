## Insight
Microsoft Windows uses several authentication protocols for multiple purposes. 
- CredSSP: The Credential Security Support Provider protocol (CredSSP) is a Security Support Provider that lets an application delegate the User's Credentials from the Client to the Target Server for Remote Authentication.
The Client is Authenticated over an Encrypted Channel by using the Simple and Protected Negotiate (SPNEGO) protocol with either Microsoft Kerberos or Microsoft NTLM.
- MSV: An authentication package for Local Machine Logons. The LSA calls the MSV1_0 Authentication Package to process Logon Data for the Winlogon Logon Process, it also supports Domain Logons. MSV1_0 processes the Domain Logons using Pass-Through Authentication, as illustrated in the following diagram:

![image](https://github.com/user-attachments/assets/a5fadfc5-2325-420d-8acf-6781eb7703ee)

- WDigest: The Digest Authentication is a protocol that is used for different Authentication Exchanges (for example; LDAP and HTTP). This protocol is similar to NTLM as it uses challenge/response protocols in order establish authentication between the Server and the Client. The Client’s challenge/response key is encrypted by the User's Password, the Server is receiving the Client Encrypted Response and compares it based on the Associated User's Credentials on AD, and then, Communication Commence. The following graph shows the process in depth:

![image](https://github.com/user-attachments/assets/3e7d3e5b-16ad-480f-a34f-8190fd4459fa)

Kerberos is a network authentication protocol that is based on using a "tickets" system to allow computers that are communicating over a non-secure network to establish trust in a secure manner.
This protocol is relaying on a third-party verification and has several advantages on NTLM, firstly, this authentication method is much faster as the ticket that is received from the client already includes all the necessary information from the client which making it faster than the challenge/response authentication of NTLM. Secondly, Kerberos in contrast to NTLM is supporting mutual authentication, meaning, that both the server and the client would have to authenticate each other. The following picture shows the authentication flow:

## Exploitation
After the user Logs-On, a variety of credentials are generated and stored in the Local Security Authority Subsystem Service process-in memory (LSASS). This is meant to facilitate Single Sign-On (SSO) ensuring that a user is not prompted each time resource-access is requested. The credential data may include Kerberos tickets, NTLM password hashes, LM password hashes (if the password is less than 15 characters, depending on Windows OS version and patch level), and even clear-text passwords (to support WDigest and SSP authentication among others). While you can prevent a Windows computer from creating the LM hash in the local computer SAM database (and the AD database), this does not prevent the system from generating the LM hash in-memory.
Known tools and techniques:
While many tools perform quite a few methods of these actions, the most common tool and perhaps the best one is Mimikatz, made by Benjamin Delpy.
Since Mimikatz  is an open source tool, different variations of it have surfaced, it is easily modified to bypass Anti-Virus software and in some cases even detection systems.
Mimikatz  and all equivalent tools require Administrative or System Access, and sometimes require Debug Mode in order to extract the needed information from different protocols.
Impact
An attacker with Administrative Access to a Host can extract Clear Text Credentials from the Host's Memory and proceed his attack into the Organizational Network.
With these credentials an attacker could possibly access different services and assets in the domain and steal or manipulate sensitive information.

![image](https://github.com/user-attachments/assets/145c95a8-5fba-4273-9520-5fefbab43262)

## Recommendations
In Windows 10 and Windows 2016, Microsoft has added a new security feature that is called "Windows Defender Credential Guard" or LSA protection. It uses a Virtualization Feature of modern CPUs in order provide a separate memory space which is isolated from the normal Operating System (at the hardware level). With the Credential Guard enabled, the LSASS process which contains the sensitive Authentication Data splits into two (2) processes, one runs in the normal OS and another runs in the Isolated Designated Virtual area. Therefore, using the Mimikatz attack on the LSA would be unsuccessful since it cannot access the isolated LSA process. The following image represents the two processes:

![image](https://github.com/user-attachments/assets/8e456e7f-412b-4eef-9eb8-4b9ade0eaa07)

When using an OS that is prior to Windows 10 or Windows Server 2016, the following steps can be applied in order to have better protection. It is recommended that you disable several settings in the organizational Group Policy:
	1. Disable SeDebugPrivilege for local administrators on every Host. This step is necessary since this Windows feature enables easy escalation of privileges over a process using the Windows API for a malicious attack. You can do that by setting GPO from: Computer Configuration -> Windows Settings -> Security Settings -> Local Policies -> User Rights Assignment > Debug Program > Enable.
	2. Disable WDigest usage by editing the following registry entry: HKEY_LOCAL_MACHINESystemCurrentControlSetControlSecurityProvidersWDigest - Set both Negotiate and UseLogonCredential to 0.
	3. It is recommended that you enable LSA protection. This can be done by creating the registry key RunAsPPL and setting the value to 1 in the following registry location: HKEY_LOCAL_MACHINESYSTEMCurrentControlSetControlLSA
	4. It is recommended that you limit the number of Cached Logins the system saves. By default the system saves the last 10 password hashes. We recommend setting it to 0 by the following this path: Computer Configuration > Windows Settings > Local Policy -> Security Options > Interactive Logon: Number of previous logons to cache > 0
> [!WARNING]
> In the event the connection with the Domain Controller is lost, the user will NOT be able to login to Host.

