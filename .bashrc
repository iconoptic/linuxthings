###############################################################################
# Brendan G's .bashrc

# COLORS!!!
# Source: http://tldp.org/LDP/abs/html/sample-bashrc.html
# Normal Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

NC="\e[m"               # Color Reset

ALERT=${BWhite}${On_Red} # Bold White on red background

###############################################################################

PS1="\[\033[1;35m\]\u@\[\033[1;36m\]\h:\[\033[1;32m\]\w\[\033[1;37m\]$"

###############################################################################

#Something from Fedora's /etc/bashrc
#I dare not touch it.

if [ "$PS1" ]; then
  if [ -z "$PROMPT_COMMAND" ]; then
    case $TERM in
    xterm*|vte*)
      if [ -e /etc/sysconfig/bash-prompt-xterm ]; then
          PROMPT_COMMAND=/etc/sysconfig/bash-prompt-xterm
      elif [ "${VTE_VERSION:-0}" -ge 3405 ]; then
          PROMPT_COMMAND="__vte_prompt_command"
      else
          PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
      fi
      ;;
    screen*)
      if [ -e /etc/sysconfig/bash-prompt-screen ]; then
          PROMPT_COMMAND=/etc/sysconfig/bash-prompt-screen
      else
          PROMPT_COMMAND='printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
      fi
      ;;
    *)
      [ -e /etc/sysconfig/bash-prompt-default ] && PROMPT_COMMAND=/etc/sysconfig/bash-prompt-default
      ;;
    esac
  fi
  # Turn on parallel history
  shopt -s histappend
  history -a
  # Turn on checkwinsize
  shopt -s checkwinsize
  [ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u@\h \W]\\$ "
  # You might want to have e.g. tty in prompt (e.g. more virtual machines)
  # and console windows
  # If you want to do so, just add e.g.
  # if [ "$PS1" ]; then
  #   PS1="[\u@\h:\l \W]\\$ "
  # fi
  # to your custom modification shell script in /etc/profile.d/ directory
fi

if ! shopt -q login_shell ; then # We're not a login shell
    # Need to redefine pathmunge, it get's undefined at the end of /etc/profile
    pathmunge () {
        case ":${PATH}:" in
            *:"$1":*)
                ;;
            *)
                if [ "$2" = "after" ] ; then
                    PATH=$PATH:$1
                else
                    PATH=$1:$PATH
                fi
        esac
    }

    # By default, we want umask to get set. This sets it for non-login shell.
    # Current threshold for system reserved uid/gids is 200
    # You could check uidgid reservation validity in
    # /usr/share/doc/setup-*/uidgid file
    if [ $UID -gt 199 ] && [ "`id -gn`" = "`id -un`" ]; then
       umask 002
    else
       umask 022
    fi

    SHELL=/bin/bash
    # Only display echos from profile.d scripts if we are no login shell
    # and interactive - otherwise just process them to set envvars
    for i in /etc/profile.d/*.sh; do
        if [ -r "$i" ]; then
            if [ "$PS1" ]; then
                . "$i"
            else
                . "$i" >/dev/null
            fi
        fi
    done

    unset i
    unset -f pathmunge
fi



rc_delim=\
###############################################################################
#### Useful for most/all installs
#Functions

rc-segment () {
	
	if [ "$1" == "--help"  ] || [ "$1" == "-h" ]
	then
		echo -e "\n${BCyan}${On_White}Truncates the text of .bashrc based on the location of the delimiters. Please make one selection.${NC}\n"
		echo -e "\n\t1:\tColor variables"
		echo -e "\t2:\tPS1\n\t3:\t/etc/bashrc... magic, I guess" 
		echo -e "\t4:\tFunctions\n\t5:\tAliases & variables"
		echo -e "\t6:\tInstallation-specific functions & aliases\n"
	else
			INDICES=( $(cat ~/.bashrc | grep -n $rc_delim |  grep -oe '[0-9]\{1,3\}') )


			case "$1" in
		
				1|colors)		cat ~/.bashrc | sed -n "$[${INDICES[0]}],$[${INDICES[1]}]p"
								;;
		
				2|PS1)			cat ~/.bashrc | sed -n "${INDICES[1]},${INDICES[2]}p"
								;;

				3|etc)			cat ~/.bashrc | sed -n "${INDICES[2]},${INDICES[3]}p"
								;;

				4|functions)	cat ~/.bashrc | sed -n "${INDICES[3]},${INDICES[4]}p"
								;;

				5|aliases)		cat ~/.bashrc | sed -n "${INDICES[4]},${INDICES[5]}p"
								;;

				6|machine)		cat ~/.bashrc | sed -n "${INDICES[5]},${INDICES[6]}p"
								;;

				7|ahelp)		cat ~/.bashrc | sed -n "${INDICES[6]},$(cat ~/.bashrc | wc -l)p"
								;;

				*)				echo -e "${ALERT}Invalid selection. Please try again or enter '-h' for more information.${NC}"
								;;

			esac

	fi


}

psearch () {

		if [[ $# -eq 1 ]]
		then
				ps aux | head -1
				ps aux | grep $1
		else
				#wrong number of arguments
				exit 1
		fi

}

prevcmd () {

		histlim="$[$HISTSIZE-2]"

		if [[ $# -eq 1 ]]
		then
				histarg="$( echo $1 | tr -d [:punct:] )"
				if [[ "$( expr match "$1" '-*[0-9]*' )" -gt 0 ]]
				then
						histarg="$[$HISTCMD-2-$histarg]"
						echo $histarg
				fi
		elif [[ $# -eq 2 ]]
		then
				histarg="$[$HISTCMD-$2]"
		elif [[ $# -eq 0 ]]
		then
				histarg="$[[$HISTCMD-2]]"
		fi

#		echo `echo $HISTSIZE-$HISTCMD+$histarg-1 | bc -l` "$(history | grep -e "\ $histarg\ \ ")"

		if [[$# -gt 2]] || [[ `echo $HISTSIZE-$HISTCMD+$histarg | bc -l` -lt $histlim ]] || [[ ! -z $1 ]] && [[ "$(expr match "$1" '*[a-z][A-Z]')" -gt 0 ]] || [[ "$(expr match "$1" '[0-9]\|-')" -lt 1  ]]
		then
				echo -e "${BWhite}${On_Blue}Error: your selection was invalid.${NC}"
				echo "You must enter between 0 and 2 arguments."
				echo "If the first argument is entered alone it will attempt to evaluate the command at the selected index."
				echo "If '-' is found in the first int, the first or second arg's integers will be subtracted from the history limit."
				echo "Integers must not be greater than $histlim or less than 1."
		else

				hexec="$(history | grep -e "\ $histarg\ \ " | cut -d " " -f 10-100000000)"

				echo -n "Are you sure you wish to execute \"$hexec\": "
				read -e confirm

				if [[ "$(expr match "$confirm" '^y$\|^Y$\|^yes$\|^Yes$')" -gt 0 ]]
				then
						eval $hexec
				else
						echo "User aborted. Exiting."
				fi

				echo -e 
		fi
}


mntntfs () {
		dev="$( lsblk -no fstype,mountpoint | grep ntfs )"
		dloc="$( lsblk -nro name,fstype | grep ntfs | awk '{ print $1 }' | xargs printf "/dev/%s\n" )"

		if [ "$( echo $dev | wc -l )" -gt 1 ]
		then
			
				printf "\t%s\t%s\n" $dev | nl	
				echo -n "Make a selection: "
				read -e devopt

				if [ "$( echo $devopt )" -gt "$( printf "\t%s\t%s\n" $dev | wc -l )" ] || [ "$( echo $devopt )" -lt 1 ]
				then
						dev=""
				else
						dev=$(printf "\t%s\t%s\n" $dev | sed -n {"$devopt"p})
						dloc=$(echo $dloc | sed -n {"$devopt"p})
						echo $dloc
				fi
		fi

		if [ "$dev" ] && [ -z "$( echo $dev | awk '{ print $2 }' )" ]
		then
				
				mloc="$1"
				while [ "$( ls -dl "$mloc" >& /dev/null ; echo $PIPESTATUS)" -ne 0 ]
				do
						echo -ne "Please enter an existing directory where you can mount $dloc: "
						read -e mloc
				done

				perms=$( echo $2 | tr [:upper:] [:lower:] )
				while [ "$perms" != "ro" ] && [ "$perms" != "rw" ]
				do
						echo -n "Please specificy the permission, either 'ro' or 'rw': "
						read -e perms
						perms=$( echo $perms | tr [:upper:] [:lower:] )
				done

				if [ "$perms" == "ro" ]
				then
						sudo mount -t ntfs -o r,auto,user,fmask=0333,dmask=0222 "$dloc" "$mloc"
				elif [ "$perms" == "rw" ]
				then
						sudo mount -t ntfs -o r,auto,user,fmask=0113,dmask=0002 "$dloc" "$mloc"
				fi	

		else
				echo "Error: the device is already mounted, or it does not exist."
		fi
}

scaling () {

		if [[ $# -ne 1 ]]; then
				if [ $2 ]; then 
						echo "Any argument after the first will be ignored."
				fi
				echo -n "Please enter a text scaling multiplier (0.5-3): "
				read -e scale
		else
				scale=$1
		fi

		if (( $(bc <<< "$scale > 3 || $scale < 0.5") )); then
				echo "The range of acceptable values is 0.5-3."
				exit 10
		fi

		dconf write /org/gnome/desktop/interface/text-scaling-factor $scale
}

pin-gen () {

		if [[ $# -gt 1 ]] || [[ $1 ]] && [[ $1 -lt 1 ]]; then # || [[ "$( echo $1 | grep -v [0-9] )" ]]; then
				echo -e "${BBlue}Error: no more than one argument accepted."
				echo -e "Argument must be a nonzero positive number, indicating the desired pin length."
				echo -e "If no arguments are entered a four digit pin will be generated.${NC}"
		else

				if [ $1 ]; then
						length=$1
				else
						length=4
				fi

				for i in `seq 1 $length`; do
						echo -n $["$(od -An -N2 -i /dev/urandom)"%9+1]
				done
				echo
		fi

}

compstr() {
		if [[ $# -eq 0 ]]
		then
				echo -ne "Enter the first string:\t\t"
				read -e arg1
				echo -ne "Enter the second string:\t"
				read -e arg2
		elif [[ $# -eq 1 ]]
		then
				echo -ne "Enter a string to compare it to:\t"
				read -e arg2
				arg1=$1
		elif [[ $# -eq 2 ]]
		then
				arg1=$1
				arg2=$2
		else
				exit 1
		fi

		if [[ $(echo -e "$arg1") == $(echo -e "$arg2") ]]
		then
				echo -e "${BGreen}The strings match.${NC}"
		else
				echo -e "${BRed}The strings do not match.${NC}"
		fi
}

crun() {
		if [[ `cat $1 | grep "#include <math.h>"` ]]
		then
				gcc -lm $1
		else
				gcc $1
		fi
		if [[ $(echo $PIPESTATUS) -eq $(echo 0) ]]
		then
				./a.out
		fi
}

ctemplate() {
		if [[ `echo $#` -eq `echo 1` ]]
		then
				if [ `echo $1 | grep '\.c$'`  ]
				then
						touch $1
						newFile=$1
				else
						touch $1.c
						newFile=$1.c
				fi
				echo -e "/*\tName: Brendan Grant\n *\tPurpose: \n */\n" >> $newFile
				echo -e "#include <stdio.h>\n" >> $newFile
				echo -e "int main (void)\n{" >> $newFile
				echo -e "\t\t" >> $newFile
				echo -e "\t\treturn 0;\n}" >> $newFile
		fi
}

clearnotes() {
		nfile=0
		if [[ `echo $1` == `echo a` ]]; then
				nfile="/home/btgrant/Documents/Ark Notes.txt"
		elif [[ `echo $1` == `echo y` ]]; then
				nfile="/home/btgrant/Documents/Yank Notes.txt"
		fi
		if [[ `echo $nfile` != 0 ]]; then
				sed -i 's/-.*$/- /g' "$nfile"
		else
				echo "Error, please enter a valid argument!"
		fi
}

###############################################################################
#Assorted Aliases and Variables

#Variables
export LOG_LEVEL=3
export HISTSIZE=10000
export HISTFILESIZE=50000
export HISTTIMEFORMAT='%A %B %d – %r '


#Aliases
#Networking
alias sshpi='ssh pi@rpi1.grant'
alias sshrouter='ssh admin@pfsense.grant'
alias wanip='sshrouter ip.sh'
alias vnstat='echo -e "${Blue}WAN IP${NC}"; wanip; sshrouter vnstat'
alias vncs='vncserver :0 -geometry 1920x1200 -depth 24'
alias getbytes="ip -d -s link show wlp2s0 | tail -3 | head -1 | cut -f5 -d' '"
alias inetbw='while true; do tcalc -d2 --quiet $(eval $getbytes; sleep 1s)-$(eval $getbytes)/1000 | grep -o "[0-9]*\..*" | xargs echo -n; echo " KB/s"; done'
alias feralvpn='sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1; sudo openvpn --config ~/vpn/client.ovpn; sudo sysctl -w net.ipv6.conf.all.disable_ipv6=0'
alias iwscan="iwlist wlp2s0 scan | egrep '\(Channel|ESSID'"

#Work

#ls
alias la='ls -a'
alias ll='ls -l'
alias lh='ll -h'
alias lha='la -lh'
alias lah='lha'
alias dirdu='find -maxdepth 1 -type d | xargs -n10 -P10 -I% du -sh % | sort -hr'

#Other
alias lsalias='alias -p'
alias vibrc='vim ~/.bashrc'
alias df='df -h'
alias testalias='echo testing'
alias greload='gtab=$(guake -g);guake -n $[$gtab+1]; guake -i $gtab -e exit'
alias lsblkc='lsblk -o size,tran,mountpoint,uuid,fstype,state,owner,sched'
alias gcc-markov='gcc -lsodium -L/home/btgrant/git/libsodium main.c'
alias apg='apg -a 1 -m 16 -x 20'
alias mpv='mpv --force-seekable'
alias dirs='dirs -v'
alias naut='dbus-run-session nautilus'

alias start-vmplayer='VMWARE_USE_SHIPPED_LIBS=force /usr/lib/vmware/bin/vmplayer'
alias fortune='fortune | cowsay -s | lolcat'

#Decryption
alias pgpdecrypt='rm -i .test*; vim .test; gpg .test; cat test.asc; echo'

#i3
alias lock='i3lock -i ~/Pictures/1423024637198.png'

alias :q='exit'

###############################################################################
#### Machine specific aliases and functions

alias cdd='cd /storage/emulated/0'
#alias ssh='ssh-autokey; ssh'
#alias scp='ssh-autokey; scp'
alias fnode1='ssh $mpi1'
alias backup='scp ~/.bashrc $nu1:/mnt/mpi-bashrc; scp ~/.bashrc $nu1:~/mpi-bashrc'


#MPI Initialization
export MPIEXEC_PORT_RANGE=44391:44391
export HYDRA_HOST_FILE=/home/mpiuser/machinefile


###############################################################################
#Help

ahelp () {
		
		echo -e "\n${BWhite}Useful commands:${NC}\n"
		echo -e "For ${BGreen}ls${NC}: la='ls -a', ll, lh='ls -lh', lha."
		echo -e "${BGreen}lsblk${NC}: calls lsblk with the following options: 'size,tran,mountpoint,uuid,fstype,state,owner,sched'."
		echo -e "${BGreen}vibrc${NC}: calls 'vim ~/.bashrc'."
		echo -e "${BGreen}prevcmd${NC}: takes 0-1 args, calls either the last commmand or the command at the specified index. Asks for confirmation."
		echo -e "${BGreen}mntntfs${NC} will mount ntfs device if available: arg1=mount location, arg2='ro'/'rw', 0-2 args accepted."
		echo -e "${BGreen}ahelp${NC}: prints this help.\n"

}
#Working command:
# find -type f | egrep -v .comp | xargs -n10 -P10 -I ,, bash -c tee >(md5sum ",," | cut -d" " -f1) >(dir=$(pwd | rev | cut -d"/" -f1 | rev); ssh btgrant@aion.feralhosting.com md5sum \"private/transmission/data/Mixed Movie Pack 46 720p BRRips DiVERSiTY/$dir/,,\" | cut -d" " -f1) | xargs echo > .comp; cat .comp | while read line; do echo $line; compstr $line; done

#Working command: # ls Game.of.Thrones.S07E05.Eastwatch.1080p.AMZN.WEB-DL.DDP5.1.H.264-GoT.mkv | xargs -n10 -P10 -I ,, bash -c tee >(md5sum ,, | cut -d  -f1) >(ssh btgrant@aion.feralhosting.com md5sum "private/transmission/data/,," | cut -d  -f1) | xargs echo > .comp; cat .comp | while read line; do echo $line; compstr $line; done

# while true; do echo `du -shb TV/Community S01-S05 - WEB-DL 720p - Team Speed/ | cut -f1`/`ssh btgrant@aion.feralhosting.com du -shb private/transmission/data/Community\ S01-S05\ -\ WEB-DL\ 720p\ -\ Team\ Speed/clear | cut -f1`*100 | xargs tcalc -q -d3 | xargs -I ,, echo -ne ${BWhite}${On_Red},,; echo -e %${NC}; sleep 30s; done
