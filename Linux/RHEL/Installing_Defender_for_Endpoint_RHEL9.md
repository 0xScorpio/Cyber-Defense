## Installing package dependencies

``` yum install yum-utils ```

## Ensure prerequisites are configured
- python3
- glibc >= 2.17
- auditd
- policycoreutils
- semanage
- SElinux policy set to Targeted
- mde-netfilter
  
If there are static proxies present, edit global environment variables under **/etc/environment**:

```
http_proxy=http://proxy.server:port/ 
https_proxy=https://proxy.server:port/
```

## Adding the Microsoft package repository for RHEL9

``` sudo yum-config-manager --add-repo=https://packages.microsoft.com/config/<OS>/<VERSION>/prod.repo ```

## Importing GPG keys

``` sudo rpm --import http://packages.microsoft.com/keys/microsoft.asc ```

## Installing and configuring Microsoft Defender for Endpoint on Linux

``` sudo yum install mdatp ```

If you're using a managed profile with Defender via portal, place a tag:

``` /usr/bin/mdatp tag set --name GROUP --value <TAG-NAME> ```

Copy over the onboarding package and extract the python file and run:

``` unzip WindowsDefendingATPOnboardingPackage.zip ```

``` python3 MicrosoftDefenderATPOnboardingLinuxServer.py ```

Ensure **/etc/opt/microsoft/mdatp/mdatp_onboard.json** is present.

Configure post-installation proxy setting:

``` mdatp config proxy set --value http://proxy.server:port ```

And check connectivity:

``` mdatp connectivity test ```

If it passes, ensure health checks are OK:

``` mdatp health ```

Set up weekly scans using cron.d for system-wide changes:

```
vi /etc/cron.d/mdatp_scan
```

This sets the scan to run weekly at 10PM every Sunday, for example.

```
00 22 * * 0 root /usr/bin/mdatp scan quick
```

## Troubleshooting CIS benchmarking issues
> [!NOTE]
> Due to CIS benchmarks requiring certain directories to be partitioned in order to set specific permissions, there is a chance that the /var directory may be set with **noexec** permissions by default. There are 2 ways I recommend on solving this. One is a 'bypass' method by remounting the directory with exec permissions, and the other one is a granular configuration using a custom SELinux policy module to set **exec** permissions on /var ONLY for the MDATP service, whilst still setting **noexec** for everything else.
>

### Bypass method - Setting default exec permissions on specific directory
Check for the directory with noexec permissions, and find the one that affects the MDATP service:

``` sudo mount | grep noexec ```

Remount directory with exec permissions:

``` sudo mount -o remount,exec /<directory> ```

Restart MDATP service and re-check health:

```
systemctl restart mdatp.service
systemctl status mdatp.service
mdatp health
```

Add persistence to the changes stated above, via the filesystem table:

```
<mounted-path> <directory> <filesystem-type> defaults,nosuid,nodev 0 0
```

### SELinux Policy module configuration
