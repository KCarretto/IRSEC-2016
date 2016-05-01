#!/bin/sh
TEMP_PASSWORD="CHANGEDLOL"
BACKUP_DIR="/lib/ /"
SECOND_DIR="/usr/share/ /"

backup()
{
	mkdir -p "$BACKUP_DIR"
	mkdir -p "$SECOND_DIR"

	#Config and Service
	tar cvp "$BACKUP_DIR/.cfg" /etc >cfg_bk 2>&1
	echo "\nBACKUP: Config Done\n"
	tar cvp "$BACKUP_DIR/.www" /var/www >www_bk 2>&1
	echo "\nBACKUP: Web Done\n"
	tar cvp "$BACKUP_DIR/.bin" /bin /sbin /usr/bin /usr/sbin >bin_bk 2>&1
	echo "\nBACKUP: Bin Done\n"

	echo "\nBACKUP-ALL: All backups have been stored to $BACKUP_DIR\n"
	echo "BACKUP: Copying Backups to secondary location"
	cp -R "$BACKUP_DIR" "$SECOND_DIR"
}

clear
echo "Turning off network interface..."
ifconfig eth0 down
echo "Done\n"

echo "Changing password to temporary solution..."
echo "root:$TEMP_PASSWORD" | chpasswd
echo "Done\n"

echo "Starting forked backup to $BACKUP_DIR"
backup &

echo "Securing logs"
chattr -R +A /var/log
echo "Done"

echo "\nSaving running processes to file ps.ini (Backgrounded)"
ps -faux > ps.ini &

echo "\nSaving running services to file svc.ini (Backgrounded)"
service --status-all > svc.ini &

echo "\n\nLogin Audit\n"
echo "sh, bash, nologin, and false comparison:"
diff $(which bash) $(which nologin)
diff $(which bash) $(which false)
diff $(which sh) $(which nologin)
diff $(which sh) $(which false)
echo "Users with shells:"
cat /etc/passwd | grep -v /bin/false | grep -v /usr/sbin/nologin | tee usr.ini
echo "==============================================================="
echo "Accounts with sudo privileges:\n"
cat /etc/sudoers | grep ALL | tee sdrs.ini
echo "==============================================================="

echo "\nMoving curl and wget to curl2 and wget2\n"
mv $(which curl) $(which curl)2 
mv $(which wget) $(which wget)2
echo "Done"

echo "\nFixing your SSHD Config\n"
chattr -i "/etc/ssh/sshd_config"
chattr -a "/etc/ssh/sshd_config"
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/'  "/etc/ssh/sshd_config"		
sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication no/' "/etc/ssh/sshd_config" 	
sed -i 's/^#*X11Forwarding.*/X11Forwarding no/' "/etc/ssh/sshd_config"			
sed -i "s/^#*AuthorizedKeysFile.*/AuthorizedKeysFile lolnope/"	"/etc/ssh/sshd_config"	
chattr +i "/etc/ssh/sshd_config"
echo "Done"
echo "\nAuthorized keys in /home:"
find /home -name authorized_keys -exec cat -1d {} \; | tee keys.ini

echo "\nQuick web shell audit: "
grep -R "shell_exec" /var/www | tee shell_exec.ini
grep -R "exec" /var/www | tee exec.ini
grep -R "password" /var/www | tee pswd.ini

echo "\n\nHere's what you need now:\n\t1.Change all passwords\n\t2.Turn on NIC, quickly download and run firewall script\n\t3.Audit the stuff above and good luck not dying.\n"
