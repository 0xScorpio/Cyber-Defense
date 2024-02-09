## Applicability: Servers, Workstations
<br>

# Audit for weak key exchange algorithms
Audit for the current KE algorithms being used, using the following command:

```
sudo sshd -T | grep kexalgorithms
```
***For a quick troubleshooting guide for sshd errors, scroll further down.
<br>

# Strong Key Exchange Algorithms that should exist
According to CIS benchmarks for SUSE Linux Enterprise 15, the only "strong" key exchange algorithms that are currently FIPS 140-2 compliant are: 
* __ECDH-SHA2-NISTP256__
* __ECDH-SHA2-NISTP384__
* __ECDH-SHA2-NISTP521__
* __Diffie-Hellman-Group-Exchange-SHA256__
* __Diffie-Hellman-Group16-SHA512__
* __Diffie-Hellman-Group18-SHA512__
* __Diffie-Hellman-Group14-SHA256__

# Weak Key Exchange Algorithms to be removed
* __Diffie-Hellman-Group1-SHA1__
* __Diffie-Hellman-Group14-SHA1__
* __Diffie-Hellman-Group-Exchange-SHA1__

# Remediation steps
Edit **/etc/ssh/sshd_config** and add/modify the MACs line to contain a comma separated list of the approved ciphers:
```
kexalgorithms ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group14-sha256
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



