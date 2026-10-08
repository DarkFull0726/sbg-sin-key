#!/bin/bash
# By Jerry_SBG - VERSIÓN DEFINITIVA
### Color
BIBlue='\033[1;94m'
BGCOLOR='\e[1;97;101m'
Wh='\033[0;37m'
NC='\033[0m'
RED='\033[31m'
YELLOW='\033[33m'
GREEN='\033[32m'
GRAY='\e[1;30m'
purple='\033[1;95m'
# BUGFIX: variables de color faltantes (causaban output roto)
BLUE='\033[1;34m'
WH='\033[1;37m'
OK="\e[1;32m[✓]\e[0m"
EROR="\e[1;31m[✗]\e[0m"
kill_zombies() {
    pkill -9 -f "apt|dpkg" 2>/dev/null
    pkill -9 -f "unattended-upgrades" 2>/dev/null
    rm -f /var/lib/dpkg/lock* 2>/dev/null
    rm -f /var/lib/apt/lists/lock 2>/dev/null
    rm -f /var/cache/apt/archives/lock 2>/dev/null
    dpkg --configure -a 2>/dev/null
}
clear
run_silent() {
    "$@" > /dev/null 2>&1
}
kill_zombies
apt install -y figlet boxes >/dev/null 2>&1
apt install -y pv >/dev/null 2>&1
unset HISTFILE
history -cw
# ===================
IVAR="/etc/http-instas"
SCPT_DIR="/var/www/html/KEY"
rm $(pwd)/$0 2>/dev/null
rm -rf /tmp/tmp.* 2>/dev/null
# BUGFIX: rm -rf /root/*.sh borraba TODOS los scripts — se limita solo a temporales conocidos
rm -f /root/sbg.sh 2>/dev/null
desofus() {
    local input="$1"
    local unrot13=$(echo "$input" | tr 'A-Za-z' 'N-ZA-Mn-za-m')
    local decoded=$(echo "$unrot13" | base64 -d 2>/dev/null)
    if [ $? -eq 0 ] && [ -n "$decoded" ]; then
        echo "$decoded" | sed 's/:[^:]*$//'
    else
        echo ""
        return 1
    fi
}
extraer_ip() {
    local key="$1"
    local datos=$(desofus "$key")
    if [ -z "$datos" ]; then
        echo ""
        return 1
    fi
    echo "$datos" | cut -d':' -f1
}
extraer_key() {
    local key="$1"
    local datos=$(desofus "$key")
    if [ -z "$datos" ]; then
        echo ""
        return 1
    fi    
    local sin_ip_puerto=$(echo "$datos" | cut -d'/' -f2-)
    echo "$sin_ip_puerto" | cut -d'/' -f1
}
extraer_usuario() {
    local key="$1"   
    local datos=$(desofus "$key")
    if [ -z "$datos" ]; then
        echo ""
        return 1
    fi
    echo "$datos" | rev | cut -d'/' -f1 | rev
}
# BUGFIX: IP duplicada e inutilizada — se usa MYIP mas adelante, esta era redundante
clear
if [ -f "/etc/xray/domain" ]; then
echo -e "[ ${YELLOW}DETECTADO ] ${BIBlue}Script ya Instalado"
echo -ne "[ ${RED}ATENCION ] ${BIBlue}¿Quieres Reinstalar tu S.O? ? (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
echo -e "[ ${YELLOW}INFORMACION${NC} ] ${BLUE}PARA DISFRUTAR DE MI SCRIPT REINSTALA TU VPS"
exit 0
else
echo -e "${BIBlue}╭═══════════════════════════════════════════╮${NC}"
echo -e "${BIBlue}│\e[1;32m Seleccione Opcion para Reinstalar su S.O  ${BIBlue}│${NC}"
echo -e "${BIBlue}╰═══════════════════════════════════════════╯${NC}"
echo -e "${BIBlue}╭═══════════════════════════════════════════╮${NC}"
echo -e "${BIBlue}│  [ 1 ]  \e[1;32mReinstalar S.O Debian 10             ${NC}"  
echo -e "${BIBlue}│  [ 2 ]  \e[1;32mReinstalar S.O Debian 11             ${NC}" 
echo -e "${BIBlue}│  [ 3 ]  \e[1;32mReinstalar S.O Debian 12             ${NC}"
echo -e "${BIBlue}│  [ 4 ]  \e[1;32mReinstalar S.O Debian 13             ${NC}"
echo -e "${BIBlue}│  [ 5 ]  \e[1;32mReinstalar S.O Ubuntu 18.04          ${NC}"  
echo -e "${BIBlue}│  [ 6 ]  \e[1;32mReinstalar S.O Ubuntu 20.04          ${NC}"  
echo -e "${BIBlue}│  [ 7 ]  \e[1;32mReinstalar S.O Ubuntu 22.04          ${NC}"  
echo -e "${BIBlue}│  [ 8 ]  \e[1;32mReinstalar S.O Ubuntu 24.04          ${NC}"  
echo -e "${BIBlue}│  [ 9 ]  \e[1;32mReinstalar S.O Ubuntu 25.04          ${NC}"                                       
echo -e "${BIBlue}╰═══════════════════════════════════════════╯${NC}"
until [[ $so =~ ^[1-9]+$ ]]; do 
read -p "   Por Favor Selecciona del 1 al 9 : " so
done
# BUGFIX: Reinstalar S.O usa server externo SBG — reemplazado por mensaje local
# Para reinstalar el S.O usa el panel de tu proveedor de VPS directamente.
echo -e "[ ${RED}INFO${NC} ] ${BLUE}Para reinstalar el S.O usa el panel de control de tu VPS."
echo -e "[ ${YELLOW}NOTA${NC} ] ${BLUE}Esta funcion requeria servidor externo (SBG) que ya no esta disponible."
exit 0
exit
fi
fi
# BUGFIX: check de --SBG removido junto con la verificacion de KEY
sleep 1 && clear
rm -rf /root/sbg.sh
clear
echo -e "  ${BIBlue}╭══════════════════════════════════════╮${NC}"
echo -e "  ${BIBlue}│ ${BGCOLOR}      ACTUALIZANDO BASE DE DATOS!   ${NC}${BIBlue} │${NC}"
echo -e "  ${BIBlue}╰══════════════════════════════════════╯${NC}"
sleep 0.5
kill_zombies
# ===== INSTALACIÓN DIRECTA SIN FUNCIONES COMPLEJAS =====
echo -e "\n${YELLOW}📦 Instalando Paquetes Esenciales:${NC}\n"
# Actualizaciones básicas
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt full-upgrade -y
# Instalar sudo
apt install sudo -y
echo "✅ sudo instalado"
# Limpiar
sudo apt-get clean all
# Instalar debconf-utils
apt install -y debconf-utils
echo "✅ debconf-utils instalado"
# Eliminar paquetes conflictivos
apt-get remove --purge ufw firewalld -y 2>/dev/null
apt-get remove --purge exim4 -y 2>/dev/null
apt-get autoremove -y
# Instalar software-properties-common
apt install -y --no-install-recommends software-properties-common
echo "✅ software-properties-common instalado"
# Configurar iptables-persistent
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
kill_zombies
# iptables
echo -n "📦 iptables... "
apt install -y iptables >/dev/null 2>&1 && echo "✅ INSTALADO" || echo "❌"
# iptables-persistent
echo -n "📦 iptables-persistent... "
apt install -y iptables-persistent >/dev/null 2>&1 && echo "✅ INSTALADO" || echo "❌"
# netfilter-persistent
echo -n "📦 netfilter-persistent... "
apt install -y netfilter-persistent >/dev/null 2>&1 && echo "✅ INSTALADO" || echo "❌"
# net-tools
echo -n "📦 net-tools... "
apt install -y net-tools >/dev/null 2>&1 && echo "✅ INSTALADO" || echo "❌"
# curl
echo -n "📦 curl... "
apt install -y curl >/dev/null 2>&1 && echo "✅ INSTALADO" || echo "❌"
# wget
echo -n "📦 wget... "
apt install -y wget >/dev/null 2>&1 && echo "✅ INSTALADO" || echo "❌"
# zip
echo -n "📦 zip... "
apt install -y zip >/dev/null 2>&1 && echo "✅ INSTALADO" || echo "❌"
# unzip
echo -n "📦 unzip... "
apt install -y unzip >/dev/null 2>&1 && echo "✅ INSTALADO" || echo "❌"
# p7zip-full
echo -n "📦 p7zip-full... "
apt install -y p7zip-full >/dev/null 2>&1 && echo "✅ INSTALADO" || echo "❌"
# cron
echo -n "📦 cron... "
apt install -y cron >/dev/null 2>&1 && echo "✅ INSTALADO" || echo "❌"
# bash-completion
echo -n "📦 bash-completion... "
apt install -y bash-completion >/dev/null 2>&1 && echo "✅ INSTALADO" || echo "❌"
# bc
echo -n "📦 bc... "
apt install -y bc >/dev/null 2>&1 && echo "✅ INSTALADO" || echo "❌"
# ntpdate
echo -n "📦 ntpdate... "
apt install -y ntpdate >/dev/null 2>&1 && echo "✅ INSTALADO" || echo "❌"
# htop
echo -n "📦 htop... "
apt install -y htop >/dev/null 2>&1 && echo "✅ INSTALADO" || echo "❌"
# vnstat
echo -n "📦 vnstat... "
apt install -y vnstat >/dev/null 2>&1 && echo "✅ INSTALADO" || echo "❌"
# chrony
echo -n "📦 chrony... "
apt install -y chrony >/dev/null 2>&1 && echo "✅ INSTALADO" || echo "❌"
echo -n "📦 fail2ban... "
apt install -y fail2ban >/dev/null 2>&1 && echo "✅ INSTALADO" || echo "❌"
cat > /etc/fail2ban/jail.local << 'EOF'
[DEFAULT]
ignoreip = 127.0.0.1/8 ::1
bantime = 3600
findtime = 600
maxretry = 3
backend = systemd
destemail = root@localhost
action = %(action_mwl)s

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600

[dropbear]
enabled = true
port = 143,110,109,69
filter = dropbear
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600

[recidive]
enabled = true
logpath = /var/log/fail2ban.log
banaction = %(banaction_allports)s
bantime = 604800   ; 1 semana
findtime = 86400   ; 1 día
maxretry = 5

[haproxy]
enabled = false

[web-ports]
enabled = true
port = 80,8080,8880,2052,2082,2086,2095,8088,8280,8888,8989,9999,8443
filter = haproxy
logpath = /var/log/haproxy.log
maxretry = 5
bantime = 3600
EOF
echo -n "📦 lolcat... "
apt install -y lolcat >/dev/null 2>&1 && echo "✅ INSTALADO" || echo "❌"
if [ -x /usr/games/lolcat ]; then
ln -sf /usr/games/lolcat /usr/bin/lolcat
echo "✅ lolcat instalado y enlazado a /usr/bin/lolcat"
elif [ -x /usr/bin/lolcat ]; then
echo "✅ lolcat ya está en /usr/bin/lolcat"
else
echo "❌ Error: No se pudo instalar lolcat"
exit 1
fi
# Eliminar servicios no deseados
sudo apt-get -y --purge remove samba* >/dev/null 2>&1
sudo apt-get -y --purge remove apache2* >/dev/null 2>&1
sudo apt-get -y --purge remove bind9* >/dev/null 2>&1
sudo apt-get -y remove sendmail* >/dev/null 2>&1
apt autoremove -y >/dev/null 2>&1
# MATAR ZOMBIES FINAL
kill_zombies
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
yellow "✅ Dependencias Instaladas Exitosamente..."
sleep 1
clear
# // Banner
echo -e "${BIBlue}╭═══════════════════════════════════════════════════╮"
echo -e " ${YELLOW}     Bienvenido al Auto-Script MOD´s EDICION${NC}"
echo -e " ${purple} Esto Configurará Rápidamente el SCRIPT en su VPS${NC}"
echo -e "    ${Wh}     Autor : ${RED}JERRY® ${NC}( ${Wh} Hecho en Mexico ${NC})${NC}"
echo -e "       ${purple}        © DEV JERRY-SBG ${NC}(${purple} 2026 ${NC})${NC}"
echo -e " ${RED}     Telegram : ${Wh}@Jerry_SBG ${NC}${RED} Grupo: ${NC}${Wh}sbg_yt${NC}"
echo -e "${BIBlue}╰═══════════════════════════════════════════════════╯"
echo ""
sleep 0.1
# // Checking Os Architecture
if [[ $( uname -m | awk '{print $1}' ) == "x86_64" ]]; then
    echo -e "${OK}${BIBlue} Su arquitectura es compatible ( ${WH}$( uname -m )${NC} )"
else
    echo -e "${EROR} Su arquitectura no es compatible ( ${YELLOW}$( uname -m )${NC} )"
    exit 1
fi
# // Checking System
if [[ $( cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g' ) == "ubuntu" ]]; then
    echo -e "${OK}${BIBlue} Su sistema Operativo es Compatible ( ${WH}$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g' )${NC} )"
elif [[ $( cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g' ) == "debian" ]]; then
    echo -e "${OK}${BIBlue} Su sistema Operativo es Compatible ( ${WH}$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g' )${NC} )"
else
    echo -e "${EROR} Su Sistema Operativo No es Compatible ( ${YELLOW}$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g' )${NC} )"
    exit 1
fi
MYIP=$(curl -s ipv4.icanhazip.com || curl -s ifconfig.me || hostname -I | awk '{print $1}')
echo -e "${OK}${BIBlue} Direccion De IP ${NC}( ${WH}$MYIP${NC} )"
echo ""
read -p "$( echo -e "${purple}Presione ${GRAY}[ ${NC}${RED}Enter${NC} ${GRAY}]${purple} Para iniciar la instalación") "
clear
echo -e "${BIBlue}╭════════════════════════════════════════════════════╮${NC}"
echo -e "${BIBlue}│   ALGUNAS VPS NECESITAN PERMISOS DE USUARIO ROOT   ${NC}${BIBlue}│${NC}"
echo -e "${BIBlue}│   COMO ORACLE, GOOGLE, AZURE, Y ALGUNOS PROVEDORES ${NC}${BIBlue}│${NC}"
echo -e "${BIBlue}│ SI TU VPS YA CUENTA CON ACCESO ROOT PRESIONA ENTER ${NC}${BIBlue}│${NC}"
echo -e "${BIBlue}│      ${BLUE}[ ${purple}By JERRY®${BLUE} ]  ${BLUE}[ ${purple}By JERRY®${BLUE} ] ${BLUE}[ ${purple}By JERRY®${BLUE} ]${NC}    ${BIBlue}│${NC}"
echo -e "${BIBlue}╰════════════════════════════════════════════════════╯${YELLOW}"
echo  ""
echo -e "[ ADVERTENCIA ] ¿Quieres Dar PERMISOS ROOT Ahora? (y/n) "; read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
clear
else
[[ "$(whoami)" != "root" ]] && {
    clear
    echo -e "\033[1;31mEJECUTE COMO USUARIO ROOT, \033[1;32m(\033[1;33msudo -i\033[1;32m)\033[0m"
    exit
}
iptables -F
echo 'nameserver 1.1.1.1' > /etc/resolv.conf
echo 'nameserver 1.0.0.1' >> /etc/resolv.conf
apt update -y
[[ $(grep -c "prohibit-password" /etc/ssh/sshd_config) != '0' ]] && {
    sed -i "s/prohibit-password/yes/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "without-password" /etc/ssh/sshd_config) != '0' ]] && {
    sed -i "s/without-password/yes/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "#PermitRootLogin" /etc/ssh/sshd_config) != '0' ]] && {
    sed -i "s/#PermitRootLogin/PermitRootLogin/g" /etc/ssh/sshd_config
} > /dev/null
# BUGFIX: usar >> en lugar de > para no sobreescribir todo el sshd_config
[[ $(grep -c "PasswordAuthentication" /etc/ssh/sshd_config) = '0' ]] && {
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "PasswordAuthentication no" /etc/ssh/sshd_config) != '0' ]] && {
    sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "#PasswordAuthentication no" /etc/ssh/sshd_config) != '0' ]] && {
    sed -i "s/#PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
} > /dev/null
# BUGFIX: solo modificar el archivo cloud si existe (no existe en sistemas viejos)
[ -f /etc/ssh/sshd_config.d/60-cloudimg-settings.conf ] && \
    sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config.d/60-cloudimg-settings.conf 2>/dev/null
service ssh restart > /dev/null
iptables -F
# BUGFIX: agregar puerto 22 (SSH) — antes faltaba y bloqueaba la conexion
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 81 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 8888 -j ACCEPT
iptables -A INPUT -p tcp --dport 8008 -j ACCEPT
iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
iptables -A INPUT -p tcp --dport 8280 -j ACCEPT
clear && echo -ne "\033[1;32mESCRIBA SU NUEVA CLAVE ROOT\033[1;37m: "; read senha
[[ -z "$senha" ]] && {
echo -e "\n\033[1;31mCLAVE INVALIDA !\033[0m"
exit 0
}
echo "root:$senha" | chpasswd
echo -e "\n\033[1;31m[ \033[1;33mOK ! \033[1;31m]\033[1;37m - \033[1;32mCLAVE DEFINIDA ! \033[0m"
fi
clear
echo -e "  ${BIBlue}╭═══════════════════════════════════════╮${NC}"
echo -e "  ${BIBlue}│ ${BGCOLOR}                ATENCION             ${NC}${BIBlue} │${NC}"
echo -e "  ${BIBlue}╰═══════════════════════════════════════╯${NC}"
echo -e "  ${BIBlue}╭═══════════════════════════════════════╮${NC}"
echo -e "   ${Wh}NO OLVIDES MANDAR CAPTURA AL ADM ${purple}JERRY®${NC}"
echo -e "      ${BGCOLOR}EVITA SER BANEADO TU SCRIPT FREE${NC}"
echo -e "      ${Wh}COMPRA TU ACCESO PREMIUM AL BOT${NC}"
echo -e "   ${Wh}ACTUALIZACIONES Y SOPORTE PERSONALIZADO${NC}"
echo -e "          ${Wh}TELEGRAM: ${YELLOW}@Jerry_SBG${NC}${BIBlue} ${NC}"
echo -e "          ${Wh}Grupo Telegram: ${YELLOW}@sbg_yt${NC}${BIBlue} ${NC}"
echo -e "  ${BIBlue}╰═══════════════════════════════════════╯${NC}"
echo ""
clear
if [ "$(systemd-detect-virt)" == "openvz" ]; then
        echo "OpenVZ no es Soportado"
        exit 1
fi
clear
###### IZIN SC 
rm -rf /etc/profil
rm -rf /usr/bin/profil2
rm -rf /etc/profil*
rm -rf /usr/bin/cred
rm -rf /usr/bin/cred*
rm -rf /usr/bin/vendor_code
rm -rf /usr/bin/vendor_code*
rm -rf /usr/bin/vendor_codes
rm -rf /usr/bin/vendor_codes*
rm -rf /usr/bin/kelly
rm -rf /usr/bin/kelly*
descargar_silencioso() {
    local url="$1"
    local destino="$2"
    wget -q --timeout=5 --tries=2 "$url" -O "$destino" 2>/dev/null
    return $?
}
clear
function SBG () {
# Verificacion de KEY desactivada — funciona 100% local
MYIP_TMP=$(curl -s ipv4.icanhazip.com 2>/dev/null || curl -s ifconfig.me 2>/dev/null || hostname -I | awk '{print $1}')
Key="LOCAL"
# BUGFIX: usar IP local del VPS en vendor_codes, no la del servidor SBG externo
IP_REAL="${MYIP_TMP}"
echo "${IP_REAL}" > /usr/bin/vendor_codes
echo "${MYIP_TMP}" > /usr/bin/vendor_code
echo "${Key}" > /usr/bin/kelly
}
SBG
cd /root
# BUGFIX: crear profil2 y cred directamente — install.zip original ya no esta disponible
echo "SOCRATES SBG" > /usr/bin/profil2
echo "KEY DE JerrySBG!" > /usr/bin/cred
chmod +x /usr/bin/profil2 /usr/bin/cred 2>/dev/null
# Limpiar cualquier sbg2.sh previo (puede ser el binario Nim original que falla)
rm -f /root/sbg2.sh 2>/dev/null
clear
checking_sc() {
clear
cols=$(tput cols)
text=" INSTALACION EN CURSO "
padding=$(((cols - ${#text}) / 2))
echo -e "\033[1;93m────────────────────────────────────────────\033[0m"
echo -ne "\033[38;5;15;48;5;208m$(printf "%*s" $padding)${text}$(printf "%*s" $padding)\033[0m"
echo " "
echo -e "\e[1;33m RESELLER: $(cat /usr/bin/profil2 2>/dev/null || echo 'SBG') ${purple}VERIFICADO \e[0m" | pv -qL 10
echo -e "\e[1;33m KEY SCRIP: $(cat /usr/bin/cred 2>/dev/null || echo 'LOCAL') ${purple}VERIFICADO \e[0m" | pv -qL 10
echo -e "              ${RED}PERMISO CONCEDIDO${NC}"
echo -e "   \033[0;33mTu IP fue Autorizado Exitosamente.${NC}"
echo -e "\033[1;93m────────────────────────────────────────────\033[0m"
sleep 1
}
checking_sc
kill_zombies
pkill -9 -f "apt.*install" 2>/dev/null
pkill -9 -f "needrestart" 2>/dev/null
rm -f /var/lib/dpkg/lock*
rm -f /var/lib/apt/lists/lock
rm -f /var/cache/apt/archives/lock
dpkg --configure -a 2>/dev/null
# Descargar sbg2.sh desde GitHub (siempre fresco — nunca usar binario previo)
echo -e "  ${YELLOW}Descargando instalador VPN desde GitHub...${NC}"
wget -q --timeout=60 --tries=3 \
    "https://raw.githubusercontent.com/DarkFull0726/sbg-sin-key/main/sbg2.sh" \
    -O /root/sbg2.sh 2>/dev/null
# Verificar que no sea el binario Nim (debe ser texto/bash)
if file /root/sbg2.sh 2>/dev/null | grep -q "ELF"; then
    rm -f /root/sbg2.sh
    echo -e "  ${RED}Error: sbg2.sh descargado es binario, reintentando...${NC}"
    wget --timeout=60 --tries=3 \
        "https://raw.githubusercontent.com/DarkFull0726/sbg-sin-key/main/sbg2.sh" \
        -O /root/sbg2.sh 2>/dev/null
fi
[ -f /root/sbg2.sh ] && chmod +x /root/sbg2.sh && bash /root/sbg2.sh --BySBG
