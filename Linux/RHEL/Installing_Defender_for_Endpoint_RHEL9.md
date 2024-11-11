## Installing package dependencies
``` yum install yum-utils ```
## Ensure prerequisites are configured
If there are static proxies present, edit global environment variables under **/etc/environment**:
```
http_proxy=http://proxy.server:port/ 
https_proxy=https://proxy.server:port/
```

## Adding the Microsoft package repository for RHEL9
``` sudo yum-config-manager --add-repo=https://packages.microsoft.com/config/<OS>/<VERSION>/prod.repo ```

## Importing GPG keys
## Configuring global environment settings proxies (Optional)
## Installing and configuring Microsoft Defender for Endpoint on Linux
