### Check for replication issues between domain controllers
```
repadmin /showrepl
```
```
repadmin /showsummary
```

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
