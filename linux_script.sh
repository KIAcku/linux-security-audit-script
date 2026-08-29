#!/bin/bash

CREATE_FILE="Automatic_脆弱性チェック_script".txt
echo "CREATE_FILE 2>&1"

echo "========01.Default:ID_Check_Start========" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

if [ ! -f "/etc/passwd" ]; 
then
    echo "/etc/passwd File not found" >> $CREATE_FILE 2>&1
else
	if [ `cat /etc/passwd | grep -E "lp|uucp|nuucp:" | wc -l` -eq 0 ];
	then
        echo "Ip,uucp,nuucp not found" >> $CREATE_FILE 2>&1
    else
    	cat /etc/passwd | grep -E "lp|luucp|nuucp:" >> $CREATE_FILE 2>&1
    fi
fi
echo " " >> $CREATE_FILE 2>&1


echo "========02.Root_Management_Start=======" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

# etc/passwd 파일을 열어서 awK -F 문법을 활용해서 etc/passwd의 

if [ ! -f /etc/passwd ]; 
then
 	echo "/etc/passwd not found" >> $CREATE_FILE 2>&1
else 
  	if [ `awk -F: '$3==0' /etc/passwd | wc -l` -eq 1 ]; 
	then
        	echo "========Good========" >> $CREATE_FILE 2>&1
	else
		awk -F: '$3==0 {print $1 " --> UID="$3 }' /etc/passwd >> $CREATE_FILE 2>&1
			
			echo "========Bad========" >> $CREATE_FILE 2>&1
	fi
fi
echo " " >> $CREATE_FILE 2>&1


echo "========03.Passwd_file_Permission_Check_start========" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1


if [ -f "/etc/passwd" ];
then
    if [ `ls -alL /etc/passwd | awk '{print $1}' | grep "rw-r--r--" | wc -l` -eq 1 ];
	then
        echo "passwd file permission check result : Good" >> $CREATE_FILE 2>&1
	else
  		echo "passwd file permission check result :  Bad" >> $CREATE_FILE 2>&1
	fi
else
		echo "/etc/passwd file not found" >> $CREATE_FILE 2>&1
fi

echo " " >> $CREATE_FILE 2>&1


echo "======== 04.GROUP_File_Permission_Check_Start ========" >> $CREATE_FILE 2>&1
ls -alL /etc/group >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

echo "=========[Result]==========" >> $CREATE_FILE 2>&1
if [ -f "/etc/group" ]; 
then
    if [ `ls -alL /etc/group | awk '{print $1}' | grep "rw-r--r--" | wc -l` -eq 0 ];
	then
        echo "group check Result : Good" >> $CREATE_FILE 2>&1
	else
        echo "group check Result :  Bad" >> $CREATE_FILE 2>&1
	
	fi
else
		echo "/etc/group file not found" >> $CREATE_FILE 2>&1
fi

if [ -f "/etc/group" ]; 
then
    if [ `cat /etc/group | grep -E "daemon|bin|sys|adm|listen|nobody|nobody4|noaccess|diag|operator|games|gopher" | grep -v "admin" | grep -v "false|nologin" | wc -l` -eq 0 ]; 
	then
        echo "shell check result : Good" >> $CREATE_FILE 2>&1
	else
		echo "shell check result :  Bad" >> $CREATE_FILE 2>&1
    fi
else
    	echo "/etc/group file not found" >> $CREATE_FILE 2>&1
fi
echo " " >> $CREATE_FILE 2>&1



echo "========05.Passwd_Rule_Check_Start========" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

if [ -f "/etc/login.defs" ];
then
	grep -v '#' /etc/login.defs | grep -i -E 'PASS_MIN_LEN|PASS_MAX_DAYS|PASS_MIN_DAYS' >> $CREATE_FILE 2>&1

else
	echo "/etc/login.defs file not found" >> $CREATE_FILE 2>&1
fi

echo "------------[Result]------------" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

if [ -f "/etc/login.defs" ];
then
	if [ `grep "PASS_MIN_LEN" /etc/login.defs | awk '{print $2}' | wc -l` -ge 1 ];
	then
       	 	 echo "PASS_MIN_LEN:[Good]" >> $CREATE_FILE 2>&1	
	else
         	 echo "PASS_MIN_LEN:[Bad: Password Length Less Then 8 ]" >> $CREATE_FILE 2>&1
    fi

	if [ `grep "PASS_MAX_DAYS" /etc/login.defs | awk '{print $2}' | wc -l` -le 90 ]; 
	then
        echo "PASS_MAX_DAYS:[Good]" >> $CREATE_FILE 2>&1
    else
		echo "PASS_MAX_DAYS:[Bad: Days Not Enough ]" >> $CREATE_FILE 2>&1
    fi

    if [ `grep "PASS_MIN_DAYS" /etc/login.defs | awk '{print $2}' | wc -l` -ge 1 ]; 
	then
         echo "PASS_MIN_DAYS:[Good]" >> $CREATE_FILE 2>&1
    else
         echo "PASS_MIN_DAYS:[Bad: Password Days Not Enough  ]" >> $CREATE_FILE 2>&1   
    fi
else
    echo "/etc/login.defs file not found." >> $CREATE_FILE 2>&1
fi
echo " " >> $CREATE_FILE 2>&1


echo "========06.Shell_Check_Start========" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

if [ -f /etc/passwd ];
then
    cat /etc/passwd | grep -E "daemon|bin|sys|adm|listen|nobody|nobody4|noaccess|diag|operator|games|gopher" >> $CREATE_FILE 2>&1
else
    echo "/etc/passwd Not Found" >> $CREATE_FILE 2>&1
fi


echo "--------------[result]----------------" >> $CREATE_FILE 2>&1

if [ `cat /etc/passwd | grep -E "daemon|bin|sys|adm|listen|nobody|nobody4|noaccess|diag|operator|games|gopher" | grep -v "admin" | grep -v "false|nologin" | wc -l` -eq 0 ]
then
    echo "Shell check result : Good" >> $CREATE_FILE 2>&1
else
    echo "Shell check result : Bad" >> $CREATE_FILE 2>&1
fi
echo " " >> $CREATE_FILE 2>&1


echo "========07.Su_Check_Start========" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

if [ -f /etc/pam.d/su ];
then
    echo "(1) /etc/pam.d/su file" >> $CREATE_FILE 2>&1
    cat /etc/pam.d/su >> $CREATE_FILE 2>&1
else
    echo "/etc/pam.d/su file not found" >> $CREATE_FILE 2>&1
fi

echo "--------[result]------------" >> $CREATE_FILE 2>&1
if [ `cat /etc/pam.d/su | grep -v 'trust' | grep 'pam_wheel.so' | grep 'use_uid' | grep -v '#' | wc -l` -eq 0　];　
then
    echo "su check result : Good" >> $CREATE_FILE 2>&1
else
    echo "su check result :  Bad" >> $CREATE_FILE 2>&1
fi
echo " " >> $CREATE_FILE 2>&1


echo "========08.Shadow check Start========" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

if [ -f /etc/shadow ]; 
then
    ls -alL /etc/shadow >> $CREATE_FILE 2>&1
else
    echo "/etc/shadow File not found" >> $CREATE_FILE 2>&1
fi
echo " " >> $CREATE_FILE 2>&1

echo "--------[RESULT]----------" >> $CREATE_FILE 2>&1

if [ `ls -alL /etc/shadow | awk '{print $1}' | grep   "----------" | wc -l` -eq 1 ]; 
then
    echo "shadow check result : Good" >> $CREATE_FILE 2>&1
else
    echo "shadow check result :  Bad" >> $CREATE_FILE 2>&1
fi
echo " " >> $CREATE_FILE 2>&1



echo "========09.Umask_Check_Start========" >> $CREATE_FILE 2>&1
echo >> $CREATE_FILE 2>&1

echo "/etc/login.defs File check " >> $CREATE_FILE 2>&1
if [ -f /etc/login.defs ]; 
then
   	cat /etc/login.defs | grep -i umask >> $CREATE_FILE 2>&1
else
    echo "/etc/login.defs file not found" >> $CREATE_FILE 2>&1
fi

echo "--------[Result]---------" >> $CREATE_FILE 2>&1

if [ `cat /etc/login.defs | grep -i "umask" | grep -v "#" | awk -F "0" '$2 >="22"' | wc -l` -gt 0 ];
then
    echo "UMASK Check Result : Good" >> $CREATE_FILE
else
    echo "UMASK Check Result :  Bad" >> $CREATE_FILE
fi

echo " " >> $CREATE_FILE 2>&1



echo "========10.Setuid,Setgid_check_start========" >> $CREATE_FILE 2>&1
echo >> $CREATE_FILE 2>&1
FILES="/sbin/dump /usr/bin/lpd-lpd /usr/bin/newgrp /sbin/restore /usr/bin/lpr /usr/sbin/lpc /sbin/unix_chkpwd /usr/sbin/lpc-lpd /usr/bin/at /usr/bin/lprm /usr/sbin/traceroute /usr/bin/lpd /usr/bin/lprm-lpd"
echo " " >> $CREATE_FILE 2>&1

for check_file in $FILES
do
        if [ -f $check_file ];
        then
                if [ `ls -alL $check_file | awk '{print $1}' | grep -i 's' | wc -l` -gt 0 ];
                then
                        ls -alL $check_file | awk '{print $1}' | grep -i 's' >> set.txt
                        ls -alL $check_file >> $CREATE_FILE
                else
                        echo " " >> set.txt
                fi
        fi
done

echo "--------[Result]--------" >> $CREATE_FILE 2>&1

if [ `cat set.txt | awk '{print $1}' | grep -i 's' | wc -l` -gt 0 ];
then
        echo "setUID check Result : Bad" >> $CREATE_FILE 2>&1     
else
        echo "setUID check result : Good" >> $CREATE_FILE 2>&1
fi

echo " " >> $CREATE_FILE 2>&1
rm -rf ./set.txt


echo "========11.Xinetd.conf_check_start========" >> $CREATE_FILE 2>&1
echo "--------[RESULT]--------" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

if [ -f /etc/xinetd.conf ];
then
	ls -alL /etc/xinetd.conf >> $CREATE_FILE 2>&1
    	if [ `ls -alL /etc/xinetd.conf | awk '{print $1}' | grep '........-.' | wc -l` -eq 1 ]
    	then
        	echo "xinetd.conf_check_result : Good" >> $CREATE_FILE 2>&1
    	else
        	echo "xinetd.conf_check_result : Bad " >> $CREATE_FILE 2>&1
   		 fi
else
    echo "xinetd.conf file not found" >> $CREATE_FILE 2>&1
fi
echo " " >> $CREATE_FILE 2>&1

echo "=====12.History_file_check_start=====" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1
HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v '/bin/false' | grep -v 'nologin' | grep -v "#"`
FILES=".sh_history .bash_history .history"

for dir in $HOMEDIRS
do
    for file in $FILES
    do
        if [ -f $dir/$file ];
        then
            if [ `ls -dal $dir/$file | awk '{print $1}' | grep "...-------" | wc -l` -eq 1 ];
            then
                echo "histroy_check_result : Good" >> history.txt
                ls -dal $dir/$file >> $CREATE_FILE
            else
                echo "history check result : Bad" >> history.txt
                ls -dal $dir/$file >> $CREATE_FILE
            fi
        else
            echo "history file not found" >> temp.txt
        fi
    done
done

echo "--------[Result]--------" >> $CREATE_FILE 2>&1
if [ `cat history.txt | grep "Bad" | wc -l` -eq 0 ];
then
    echo "history check result : Good " >> $CREATE_FILE
else
    echo "history check result : Bad" >> $CREATE_FILE
fi

echo " " >> $CREATE_FILE 2>&1
rm -rf ./history.txt




echo "========13.Profile_permission_Check_start ========" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

if [ -f /etc/profile ];
then
    ls -alL /etc/profile >> $CREATE_FILE 2>&1
else
    echo "/etc/profile not found" >> $CREATE_FILE 2>&1
fi

echo "--------[Result]--------" >> $CREATE_FILE 2>&1
if [ `ls -alL /etc/profile | awk '{print $1}' | grep '...-.--.--' | wc -l` -eq 1 ]; 
then
    echo "profile permission check result : Good" >> $CREATE_FILE 2>&1
else
    echo "profile permission check result : Bad " >> $CREATE_FILE 2>&1
fi

echo " " >> $CREATE_FILE 2>&1



echo "========14.Hosts_Permission_check_start ========" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

if [ -f /etc/hosts ];
then
        ls -alL /etc/hosts >> $CREATE_FILE 2>&1
else
        echo "/etc/hosts file not found" >> $CREATE_FILE 2>&1
fi

echo "--------[Result]--------" >> $CREATE_FILE 2>&1
if [ `ls -alL /etc/hosts | awk '{print $1}' | grep '-rw-r--r--' | wc -l` -eq 0 ];
then
        echo "permssion  check result : Good" >>$CREATE_FILE 2>&1
else
        echo "permissionm check result : Bad" >> $CREATE_FILE 2>&1
fi

echo " " >> $CREATE_FILE 2>&1



echo "========15.Issue_permission_check_start ========" >> $CREATE_FILE 2>&1
if [ -f /etc/issue ];
then
        ls -alL /etc/issue >> $CREATE_FILE 2>&1
else
        echo "/etc/issue file not found" >> $CREATE_FILE 2>&1
fi

echo "--------[result]--------" >> $CREATE_FILE 2>&1
if [ `ls -alL /etc/issue | awk '{print $1}' | grep '.....--.--' | wc -l` -eq 1 ]; 
then
        echo "issue permission check result : Good" >> $CREATE_FILE 2>&1
else
        echo "issue permission check result : Bad" >> $CREATE_FILE 2>&1
fi

echo " " >> $CREATE_FILE 2>&1



echo "--------[Home_directory_start]--------" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1
HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v "#" | grep -v "/tmp" | grep -v "uucppublic" | uniq`
echo " " >> $CREATE_FILE 2>&1

for dir in $HOMEDIRS
do
    ls -dal $dir | grep '^d.......' >> $CREATE_FILE 2>&1
done

echo " " >> $CREATE_FILE 2>&1
echo " " > home.txt

echo "--------[Home_Dir_result]---------" >> home.txt 2>&1
for dir in $HOMEDIRS
do
    if [ -d $dir ];
    then
        if [ `ls -dal $dir | awk '{print $1}' | grep ".....--.--" | wc -l` -eq 1 ]; 
		then 
            echo "HOME directory permission check result : Good" >> home.txt
        else
            echo "HOME directory permission check result : Bad" >> home.txt
        fi
    else
        echo "HOME Directory permission check result : Good" >> home.txt
    fi
done

echo " " >> home.txt 2>&1
echo " " >> $CREATE_FILE 2>&1


echo "========17_Home_directory_configuration_check=========" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1
HOMEDIRS=`cat /etc/passwd | awk -F ":" 'length($6) > 0 {print $6}' | sort -u | grep -v '/bin/false' | grep -v 'nologin' | grep -v "#"`
FILES=".profile .cshrc .kshrc .login .bash_profile .bashrc .bash_login .exrc .netrc .history .sh_history .bash_history .dtprofile"

for dir in $HOMEDIRS
do
    for file in $FILES
    do
        if [ -f $dir/$file ]; 
		then
            if [ `ls -alL $dir/$file | awk '{print $1}' | grep ".....__.__" | wc -l` -eq 1 ]; 
			then
                echo "Home configuration check result : Good" >> homeconf.txt
            else
                echo "Home configuration check result : Bad" >> homeconf.txt
			fi
		else
		fi
    done
done

echo "========[Result]========" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

if [ `cat homeconf.txt | grep "Bad" | wc -l` -eq 0 ]; 
then
		echo "home configuration check result :Good" >> $CREATE_FILE 2>&1
else
        echo "home configuration check result :Bad" >> $CREATE_FILE 2>&1
fi

cat ./homeconf.txt
rm -rf homeconf.txt

echo " " >> $CREATE_FILE 2>&1





echo "======18_Directory_file_permission_check_start======" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

HOMEDIRS="/sbin /etc /bin /usr/bin /usr/sbin /usr/lbin"

for dir in $HOMEDIRS
do
    ls -dal $dir | grep "d........" >> $CREATE_FILE 2>&1
done

echo " " >> $CREATE_FILE 2>&1
echo " " > dir.txt

echo "--------[Directory_result] --------" >> dir.txt
echo " " >> dir.txt 2>&1

HOMEDIRS="/sbin /etc /bin /usr/bin /usr/sbin /usr/lbin"

for dir in $HOMEDIRS
do
    if [ -d $dir ];
    then
        if [ `ls -dal $dir | awk '{print $1}' | grep "........-." | wc -l` -eq 0 ]; 
		then
            echo "Directory permission check result: Good" >> dir.txt
		else
            echo "Directory permission check result: Bad" >> dir.txt
		fi
	else
        echo "Directory permission check result : Good" >> dir.txt
	    echo " " >> dir.txt 2>&1
		echo "--------[Directory_Result_End]--------" >> dir.txt
    fi
done

cat ./dir.txt

echo "========[Result]========" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1
if [ `cat dir.txt | grep "Bad" | wc -l` -eq 0 ];
then
    echo "directory file permissiom check result: Good" >> $CREATE_FILE 2>&1
else
    echo "directory file permission check result: Bad" >> $CREATE_FILE 2>&1
fi

cat ./dir.txt
rm -rf ./dir.txt

echo " " >> $CREATE_FILE 2>&1



echo "========[19_PATH_conf_check_start]========" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

if [ `echo $PATH | grep "\.:" | wc -l` -eq 0 ];
then
    echo "path conf check result : Good" >> $CREATE_FILE 2>&1
else
    echo "path conf check result : Bad" >> $CREATE_FILE 2>&1
fi

echo " " >> $CREATE_FILE 2>&1



echo "======[20_Root_remote_permission_check_start]======" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

if [ -f /etc/pam.d/login ];
then
        if [ `ls -alL /etc/pam.d/login | awk '{print$1}' | grep '.......-.' | wc -l` -eq 0 ];
		then
				echo "root remote file permission check result : Bad" >> $CREATE_FILE 2>&1
		else
		        echo "root remote file permission check result : Good" >> $CREATE_FILE 2>&1
		fi
else
        echo "root remote file permission check result: Good" >>$CREATE_FILE 2>&1
fi

echo " " >> $CREATE_FILE 2>&1



echo "====[21_ETC_file_permission_check_start]====" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

DIR744="/etc/rc*.d/* /etc/inittab /etc/syslog.conf /etc/snmp/conf/snmpd.conf"

echo " " >> $CREATE_FILE 2>&1
echo " " > etcfiles.txt
echo "--------[ETC_file_Result_start]---------" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

for check_dir in $DIR744
do
	if [ -f $check_dir ];
	then
		if [ `ls -alL $check_dir | awk '{print$1}' | grep '.......w.' | wc -l` -eq 0 ]; 
		then
           
			echo "ETC file permission check result:Good" >> etcfiles.txt

        else
            echo "ETC file permission check result: Bad" >> etcfiles.txt

        fi

    fi

done

echo " " >> $CREATE_FILE 2>&1
echo "-------[ETC_file_Check_END]-------" >> $CREATE_FILE 2>&1
echo "=======[Final_Result]======" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

if [ `cat etcfiles.txt | grep "Bad" | wc -l` -eq 0 ]; 
then
	echo "ETC files permission check result :good" >> $CREATE_FILE 2>&1

else
	 echo "ETC files permission check result :Bad" >> $CREATE_FILE 2>&1

fi

rm -rf etcfiles.txt

echo " " >> $CREATE_FILE 2>&1

echo "====[22_RPC service START]====" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

SERVICE_INETD="rpc.cmsd|rpc.ttdbserverd|sadmind|rusersd|walld|sprayd|rstatd|rpc.nisd|rpc.pcnfsc|rpc.statd|rpc.ypupdated|rpc.rquotad|kcms_server|cachefsd|rexd"

if [ -d /etc/xinetd.d ]; 
then
        if [ `ls -alL /etc/xinetd.d | grep -E $SERVICE_INETD | wc -l` -eq 0 ]; 
        then
                echo "RPC service not found" >> $CREATE_FILE 2>&1
        else
                ls -alL /etc/xinetd.d | grep -E $SERVICE_INETD >> $CREATE_FILE 2>&1
        fi
else
        echo "/etc/xinetd.d Directory not found" >> $CREATE_FILE 2>&1
fi

echo " " >> $CREATE_FILE 2>&1

if [ -d /etc/xinetd.d ]; 
then
        if [ `ls -alL /etc/xinetd.d | grep -E $SERVICE_INETD | wc -l` -gt 0 ]; 
		then
                for check in `ls -alL /etc/xinetd.d | grep $SERVICE_INETD | awk '{print $9}'`
               
				do
                        if [ `cat /etc/xinetd.d/$check | grep -i "disable" | grep -i "no" | wc -l` -eq 0 ]; 
                        then
                                echo "RPC Servive check result : Bad" >> rpc.txt
                        else
                                echo "RPC Service check result : Good" >> rpc.txt
                        fi
                done
        else
                echo "RPC service check result : Good" >> rpc.txt
        fi
fi

cat ./rpc.txt >> $CREATE_FILE

echo "========[Result]========" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

if [ `cat rpc.txt | grep "Bad" | wc -l` -eq 0 ];
then
        echo "RPC Service check result : Good" >> $CREATE_FILE 2>&1
else
        echo "RPC Service check result  : Bad" >> $CREATE_FILE 2>&1
fi

rm -rf rpc.txt

echo " " >> $CREATE_FILE 2>&1
echo "===================[Automatic_脆弱性チェック_script.END]========================" >> $CREATE_FILE 2>&1

cat ./$CREATE_FILE








