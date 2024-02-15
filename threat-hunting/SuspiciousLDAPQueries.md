# Suspicious LDAP Queries w/ Defender ATP

Event Viewer: 1643, 1644

## Known LDAP queries used for enumeration
```
    ### All Security Groups in AD ###
    (&(samaccounttype=268435456))

    #### All non-security groups ###
    (&(samaccounttype=268435457))

    #### All groups in the Built-In container ###
    (&(samaccounttype=536870912)) : All the groups in the Builtin container

    ### NON_SECURITY_ALIAS_OBJECT ###
    (&(samaccounttype=536870913)) : NON_SECURITY_ALIAS_OBJECT

    ### Relative Identifier(RID) for the primary group of use ###
    (&(primarygroupid=*))

    ### All Computer objects in AD ###
    (&(sAMAccountType=805306369)

    ### All enabled accounts in AD ###
    (!(UserAccountControl:1.2.840.113556.1.4.803:=2))

    ### Every account in AD ###
    (|(samAccountType=805306368))

    ### All Domains ###
    ((objectClass=domain))

    ### All GPOs ###
    (&(objectcategory=groupPolicyContainer))

    ### All Organizational Units ###
    (& (objectcategory=organizationalUnit))

    ### All accounts with an SPN ###
    (& (serviceprincipalname=*))

    ### SPN User accounts - could be used for bruteforcing TGS ###
    ((&(objectCategory=user)(servicePrincipalName=*)))

    ### Enumerate sensitive AD groups ###
    (&(adminCount=1)(objectClass=group))’).FindAll()

    ### Enumerate all computers ###
    (objectCategory=computer)’).FindAll()

    ### Enumerate all global security groups ###
    (groupType=-2147483646)’).FindAll()

    ### Enumerate all enabled accounts ###
    (&(objectCategory=person)(objectClass=user)(!(userAccountControl
    :1.2.840.113556.1.4.803:=2)))’).FindAll()

    ### Enumerate for accounts with Kerberos Pre-Auth disabled -- vulnerable to AS-REP roasting ###
    (&(objectCategory=person)(objectClass=user)(userAccountControl:1.2.840.113556.1.4.803:=4194304))’).FindAll()
```

In order to identify malicious LDAP activity, we'll need to turn on logging. We can enable advanced auditing on the domain controller via:
```
auditpol /set /subcategory:"Directory Service Access" /Success:Enable
```

Under __HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NTDS\Parameters\Diagnostics__, set "15 Field Engineering" to 5.
<br>

Then, navigate to __HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NTDS\Parameters__.
<br>

Then create 2 DWORD values:
- __Expensive Search Results Threshold__
- __Inefficient Search Results Threshold__
<br>

And set the values to 1.

This will generate events in the Directory Services event log for every LDAP query.

Now we can enumerate user accounts in DC and then detect both object access and LDAP queries:
```
$searcher = New-Object DirectoryServices.DirectorySearcher
$searcher.SearchRoot = 'LDAP://DC=DOMAIN,DC=local'
$searcher.Filter = '(&(objectClass=user))'

$list = $searcher.FindAll() | Sort-Object PATH
foreach ($user in $list) {
  Write-Host $user.Properties["cn"]
}
Write-Host "--------------------"
Write-Host "Number of users returned: " @($res).count
Write-Host "--------------------"

```

Last but not least, find Event 4662 for object access and Events 1643 and 1644 for LDAP query sourcing.

