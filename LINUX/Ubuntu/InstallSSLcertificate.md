# Prerequisites
- certificate.crt
- ca-bundle/chain.crt
- private.key

Copy certificate.crt and ca-bundle.crt into __/etc/ssl__.
Copy private.key into __/etc/ssl/private__.

# Edit the Apache configuration file
The usual location is in __/etc/apache2/sites-enabled/SITE-NAME__.
If you aren't able to find it, you can locate it via:
```
sudo a2ensite SITE-NAME
```

***NOTE: To access your site via both HTTP and HTTPS, there must be separate files in the sites-enabled folder, based on their ports. For example:
```
/etc/apache2/sites-enabled/SITE-NAME/80
/etc/apache2/sites-enabled/SITE-NAME/443
```

# Configure the Virtual Host block
*This ensures your site is only accessible via HTTPS. The virtual host block should contain the following:
```
<VirtualHost *:443>
  DocumentRoot /var/www/SITE-NAME
  ServerName SITE-NAME.DOMAIN.COM
  SSLEngine on
  SSLCertificateFile /etc/ssl/certificate.crt
  SSLCertificateKeyFile /etc/ssl/private/private.key
  SSLCertificateChainFile /etc/ssl/ca-bundle.crt
</VirtualHost>
```
*If the SSLCertificateFile directive does not work, use the SSCACertificateFile instead.
*Default virtual host block can be found within the main httpd.conf file via: __/etc/httpd/conf/httpd.conf__
Save the .config file.

# Test the configuration file
```
apachectl configtest
```

# Restart Apache
```
apachectl stop
apachectl start
```
