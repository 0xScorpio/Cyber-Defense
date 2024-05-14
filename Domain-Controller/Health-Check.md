### Check for replication issues between domain controllers
![image](https://github.com/0xScorpio/Cyber-Defense/assets/140411254/b8a48b09-2ea1-4801-b7f5-09d77b90d1ff)
```
repadmin /showrepl
```
```
repadmin /showsummary
```
You will see two tables with stats, the first one is the Source DSA. These are the stats for the outgoing replications. The latter, Destination DSA are the incoming replications.

The largest Delta tells us the longest time a connection between two domain controllers isn’t used. Now this can go up to 60 min, which is actually pretty normal. Within your domain, some changes are replicated within seconds, like password resets. But others, like schema changes, don’t happen that often and are only checked once per hour. The domain controllers check at least (pol) every hour for changes, so that is why the time can get up to 60 minutes.

The field total shows the number of replication links the domain controller has. Fails tells us how many of those are failed (should be zero of course) and %% is the percentage of the failed links out of the total.

When there is an error, then the error code is shown in the error field.

### DC Diagnostic tool
DCDiag options go after the command and an optional identifier for a remote domain controller. You can get a list of them by entering dcdiag /? Or dcdiag /h. Here is the list:

    /a Test all domain controllers on this site.
    /e Test all domain controllers for this enterprise.
    /q Quiet mode. Only show error messages.
    /v Verbose mode. Display detailed information on each test.
    /c Comprehensive mode. Run all tests except DCPromo, RegisterInDNS, Topology, CutoffServers, and OutboundSecureChannels.
    /i Ignore superfluous error messages.
    /fix Fix the Service Principal Name (only for the MachineAccount test).
    /f: <filename> Send all output to the named file.
    /test: <testname> Perform only the named test.
    /skip: <testname> Skip the named test from the series.
    /ReplSource: <SourceDomainController> Test the relationship between the subject DC and the named DC.

```
dcdiag /test:DNS
```
For more diagnostic /test options:

- DNSBasic Basic tests, such as connectivity, DNS client configuration, service availability, and zone existence.
- DnsForwarders Checks the configuration of forwarders plus the DnsBasic tests.
- DnsDelegation Checks for proper delegations plus the DnsBasic tests.
- DnsDynamicUpdate Checks whether a dynamic update is enabled in the Active Directory zone plus the DnsBasic tests.
- DnsRecordRegistration Checks if the address (A), canonical name (CNAME), and well-known service (SRV) resource records are registered, creating an inventory report. Also performs the DnsBasic tests.
- DnsResolveExtName [/DnsInternetName:<InternetName>] Tests the DNS records by resolving Microsoft.com. if the optional DnsInternetName is specified, this will be resolved instead. Also runs the DnsBasic tests.
- DnsAll Performs all tests, except for DnsResolveExtName.

### Check services and their status
```powershell
$Services='DNS','DFS Replication','Intersite Messaging','Kerberos Key Distribution Center','NetLogon',’Active Directory Domain Services’
ForEach ($Service in $Services) {Get-Service $Service}
```
