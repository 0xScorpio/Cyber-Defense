#!/bin/bash

# SUSE Linux Enterprise Server 15 - CIS Benchmarks Audit

#Global variables
color_green="\e[32m"
color_red="\e[31m"
color_yellow="\e[33m"
color_reset="\e[0m"

#Check MAC Algorithms
echo "Searching /etc/ssh/sshd_config for MAC algorithms..."
checkMACalgorithms=$(grep -i "MACs" /etc/ssh/sshd_config)
if [ -n "$checkMACalgorithms" ]; then 
	echo "--------"
    echo -e "Current MAC configuration: ${color_yellow}$checkMACalgorithms${color_reset}"
    echo "--------"
    echo -e "CIS Benchmark: ${color_green}macs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256${color_reset}"
    echo "--------"
else
    echo -e "${color_red}Can't find MAC algorithms!${color_reset}"
fi

#Check Key Exchange Algorithms
echo "Searching /etc/ssh/sshd_config for KEY-EXCHANGE algorithms..."
checkKEalgorithms=$(grep -i "kexalgorithms" /etc/ssh/sshd_config)
if [ -n "$checkKEalgorithms" ]; then
	echo "--------"
	echo -e "Current KE configuration: ${color_yellow}$checkKEalgorithms${color_reset}"
    echo "--------"
    echo -e "CIS Benchmarks: ${color_green}kexalgorithms ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group14-sha256${color_reset}"
    echo "--------"
else
    echo -e "${color_red}Can't find KEY EXCHANGE algorithms!${color_reset}"
fi

#Check Ciphers
echo "Searching /etc/ssh/sshd_config for CIPHERS..."
checkCiphers=$(grep -i "ciphers" /etc/ssh/sshd_config)
if [ -n "$checkCiphers" ]; then
	echo "--------"
	echo -e "Current Ciphers configuration: ${color_yellow}$checkCiphers${color_reset}"
	echo "--------"
	echo -e "CIS Benchmarks: ${color_green}ciphers chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com${color_reset}"
	echo "--------"
else
	echo -e "${color_red}Can't find CIPHERS!${color_reset}"
fi
