#!/usr/bin/bash

stty -echoctl

BRed='\033[1;31m' 
NC='\033[0m'
BBlue='\033[1;34m'
BGreen='\033[1;32m'

trap ''  QUIT
trap ''  TSTP
trap 'echo -e "${BBlue} [$(date +"%T")] ${NC} ${BGreen} GoodBye! ${NC}"' EXIT

delete_everything(){
	dir_folder=$1
	if [ $(find $dir_folder -type f | wc -l) -gt 0 ]; then
		echo -e "${BGreen} [$(date +"%T")] Trashing $(find $dir_folder -type f | wc -l) Files ${NC}"; find $dir_folder -type f -exec shred -n 40 -fuz {} \;;fi
	if [ $(find $dir_folder -not -path $dir_folder -prune -type d | wc -l) -gt 0 ]; 
		then echo -e "${BGreen} [$(date +"%T")] Trashing $(find $dir_folder -not -path $dir_folder -prune -type d | wc -l) Directories ${NC}";
		find $dir_folder -not -path $dir_folder -prune -type d -exec srm -rfllz {} \;;fi
}

banner(){
clear
sleep 0.5
echo -e "${BRed}        
                                                                                              
	@@@@@@@  @@@@@@@    @@@@@@    @@@@@@   @@@  @@@      @@@@@@   @@@@@@@@   @@@@@@@  @@@  @@@  @@@@@@@   @@@@@@@@  
	@@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@   @@@  @@@     @@@@@@@   @@@@@@@@  @@@@@@@@  @@@  @@@  @@@@@@@@  @@@@@@@@  
	  @@!    @@!  @@@  @@!  @@@  !@@       @@!  @@@     !@@       @@!       !@@       @@!  @@@  @@!  @@@  @@!       
	  !@!    !@!  @!@  !@!  @!@  !@!       !@!  @!@     !@!       !@!       !@!       !@!  @!@  !@!  @!@  !@!       
	  @!!    @!@!!@!   @!@!@!@!  !!@@!!    @!@!@!@!     !!@@!!    @!!!:!    !@!       @!@  !@!  @!@!!@!   @!!!:!    
	  !!!    !!@!@!    !!!@!!!!   !!@!!!   !!!@!!!!      !!@!!!   !!!!!:    !!!       !@!  !!!  !!@!@!    !!!!!:    
	  !!:    !!: :!!   !!:  !!!       !:!  !!:  !!!          !:!  !!:       :!!       !!:  !!!  !!: :!!   !!:       
	  :!:    :!:  !:!  :!:  !:!      !:!   :!:  !:!         !:!   :!:       :!:       :!:  !:!  :!:  !:!  :!:       
	   ::    ::   :::  ::   :::  :::: ::   ::   :::     :::: ::    :: ::::   ::: :::  ::::: ::  ::   :::   :: ::::  
	   :      :   : :   :   : :  :: : :     :   : :     :: : :    : :: ::    :: :: :   : :  :    :   : :  : :: ::   

${NC}"
sleep 0.5
}

check_packages(){
	pkgs='secure-delete'
	if ! dpkg -s $pkgs >/dev/null 2>&1; then 
	echo -e "${BRed} [-] Secure-delete is not installed ${NC}"; 
	echo -e "${BRed} [-] Install using: sudo apt-get install -y secure-delete ${NC}";
	exit; fi
}

if [ "$EUID" -ne 0 ]
  then
  	check_packages
  	banner
	echo -e "${BBlue} [$(date +"%T")] Starting Secure Trash ${NC}"
 	echo -e "${BBlue} [$(date +"%T")] https://github.com/kevinification/trashSecure ${NC}"
	echo -e "${BBlue} [$(date +"%T")] Press ${BRed} Ctrl + C ${NC} ${BBlue}to exit script ${NC}"
	sleep 0.2
	folder1=~/.local/share/Trash/files
	folder2=~/.local/share/Trash/info
	if [[ -d "$folder1" ]]; then echo -e "${BBlue} [$(date +"%T")] Trashing Bin ${NC}"; delete_everything $folder1; fi
	sleep 0.2
	if [[ -d "$folder2" ]]; then echo -e "${BBlue} [$(date +"%T")] Trashing Bin Information ${NC}"; delete_everything $folder2; fi
	sleep 0.5
	echo -e "${BBlue} [$(date +"%T")] Secure Trash Done Successfully${NC}"
else echo -e "${BRed} [-] Script Cannot Be Run As Root ${NC}"; exit; fi
