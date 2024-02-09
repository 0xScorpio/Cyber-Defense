## Applicability: Servers, Workstations
<br>

# Audit for weak algorithms
Audit for the current algorithms being used, using the following command:

```
sudo sshd -T | grep -i "MACs"
```
***For a quick troubleshooting guide for sshd errors, scroll further down.
<br>

# Strong Algorithms that should exist
According to CIS benchmarks for SUSE Linux Enterprise 15, the only "strong" algorithms that are currently FIPS 140-2 compliant are: 
* __HMAC-SHA2-512-ETM__
* __HMAC-SHA2-256-ETM__
* __HMAC-SHA2-512__
* __HMAC-SHA2-256__
# Weak Algorithms to be removed
* __HMAC-MD5__
* __HMAC-MD5-96__
* __HMAC-RIPEMD160__
* __HMAC-SHA1__
* __HMAC-SHA1-96__
* __<span>UMAC-64<span>@openssh.com__
* __<span>UMAC-128<span>@openssh.com__
* __<span>HMAC-MD5-ETM<span>@openssh.com__
* __<span>HMAC-MD5-96-ETM<span>@openssh.com__
* __<span>HMAC-RIPEMD160-ETM<span>@openssh.com__
* __<span>HMAC-SHA1-ETM<span>@openssh.com__
* __<span>HMAC-SHA1-96-ETM<span>@openssh.com__
* __<span>UMAC-64-ETM<span>@openssh.com__
* __<span>UMAC-128-ETM<span>@openssh.com__

# Remediation steps
Edit **/etc/ssh/sshd_config** and add/modify the MACs line to contain a comma separated list of the approved ciphers:
```
macs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256
```

<br> 

# Troubleshooting sshd
***If you get an error regarding sshd not found ensure the following:
1. Make sure 'sshd' is installed:
```
sudo systemctl status sshd
```  
* If it is installed follow steps [2] and [3]. Else, install 'sshd' unto the server:
```
sudo zypper refresh
```
```
sudo zypper install openssh
```
<br>

2. Ensure 'sshd' service is running/active:
```
sudo systemctl start sshd
```
```
sudo systemctl enable sshd
```
<br>

3. sshd binary is placed as an environment path variable
If the issue persists, then find the sshd binary:
```
sudo find / -name sshd
```
And look for the correct system binary:  **/usr/sbin/sshd** and proceed by placing the directory path into PATH:
```
export PATH="/usr/sbin:$PATH"
```




