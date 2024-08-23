Roasting attacks exploit the Windows Kerberos protocol to obtain packets sent from the Key Distribution Center (KDC). AS-REP Roasting leverages users with the attribute 'DONT_REQUIRE_PREAUTH', thereby allowing adversaries to obtain AS-Response packets from them without prior authentication. As each AS-Response packet is encrypted using a specific user's NTLM hash, it can be cracked offline using brute-force or dictionary techniques to reveal the user's cleartext password.

## Impact
Kerberos pre-authentication is used to verify the user's identity by encrypting the clock-time with the NTLM hash of the requested user. 
Once the KDC receives the encrypted clock-time from the user, it encrypts it and compares the timestamps. If it all checks out, the identity of the user is verified. The KDC then sends back an AS-REP session key again encrypted with the user's NTLM hash, and a TGT.
Pre-authentication can be disabled for specific users. 'DONT_REQUIRE_PREAUTH' is an AD attribute set to a specific user which simply instructs the KDC to skip the pre-authentication procedure. This configuration is not a security flaw in itself. 
Pentera can obtain an AS-REP for any user who has this attribute setting, without prior authentication. Pentera can then continue its efforts offline to decrypt the user's AS-REP and reveal the user's cleartext password.
It's worth noting that Pentera cannot leverage the user's 'stolen' TGT since it cannot decrypt the session key in the AS-REP packet without already knowing the user's NTLM hash. 

## Recommendations
	• Avoid disabling preauthorization for any user, unless absolutely necessary. In other words, don't enable the flag: DONT_REQUIRE_PREAUTH.
	• Enforce proper password hygiene and complexity. The weakest link are always easily-guessed passwords.
	
## Technical Enforcement 
	• Query all users with DONT_REQUIRE_PREAUTH using an LDAP query: 
(&(samAccountType=805306368)(userAccountControl:1.2.840.113556.1.4.803:=4194304))
If there are any, unset the attribute.
Enforce password complexity in the domain environment.
