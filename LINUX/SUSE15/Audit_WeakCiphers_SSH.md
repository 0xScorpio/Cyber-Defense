## Applicability: Servers, Workstations
<br>

# Audit for weak ciphers
Audit for the current ciphers being used using the following command:

```
sudo sshd -T | grep ciphers
```
***For a quick troubleshooting guide for sshd errors, scroll further down.
<br>

# Strong Ciphers that should exist
According to CIS benchmarks for SUSE Linux Enterprise 15, the only "strong" ciphers that are currently FIPS 140-2 compliant are: 
* __AES256-CTR__
* __AES192-CTR__
* __AES128-CTR__
# Weak Ciphers to be removed
* __3DES-CBC__
* __AES128-CBC__
* __AES192-CBC__
* __AES256-CBC__

# Remediation steps
Edit **/etc/ssh/sshd_config** and add/modify the Ciphers line to contain a comma separated list of the approved ciphers:
```
ciphers chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com
```

<br> 

# Troubleshooting process
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





