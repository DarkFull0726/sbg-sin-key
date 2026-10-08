#!/bin/bash
NC='\e[0m'
colornow=$(cat /etc/rmbl/theme/color.conf)
export NC="\e[0m"
export COLOR1="$(cat /etc/rmbl/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
rm -rf $(pwd)/$0
clear
echo -e "${COLOR1}╭═══════════════════════════════════════════╮${NC}"
echo -e "${COLOR1}│$NC     \e[1;32mCONFIGURA IP/SUBDOMINIO/DOMINIO       ${NC}${COLOR1}│${NC}"
echo -e "${COLOR1}╰═══════════════════════════════════════════╯${NC}"
echo -e " "
read -p "   Ingresa tu Ip/Subdominio/Dominio : " domain
echo -e " "
echo -e "${COLOR1}╭═══════════════════════════════════════════╮${NC}"
echo -e "${COLOR1}│           \e[1;32mCREAR OBFS PERSONALIZADO        ${NC}${COLOR1}│${NC}"
echo -e "${COLOR1}╰═══════════════════════════════════════════╯${NC}"
echo -e " "
read -p "   Ingresa tu OBFS o ENTER para una Aletorio : " OBFS
    [[ -z "$OBFS" ]] && OBFS=`head /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 8`
echo -e "   \e[1;32mDescargando UDPMOD desde GitHub..."
wget -q --show-progress https://github.com/DarkFull0726/sbg-sin-key/raw/main/scripts/UDPMOD/UDPMOD.zip -O UDPMOD.zip
unzip -o UDPMOD.zip
chmod 755 UDPMOD/*
rm -rf UDPMOD.zip

echo -e "   \e[1;32mInstalando Hysteria y Configurando, Espera..."

dir=$(pwd)

interfas=$(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1)

sys=$(which sysctl)

ip4t=$(which iptables)
ip6t=$(which ip6tables)

openssl genrsa -out ${dir}/UDPMOD/udpmod.ca.key 2048 2>/dev/null
openssl req -new -x509 -days 3650 -key ${dir}/UDPMOD/udpmod.ca.key -subj "/C=CN/ST=GD/L=SZ/O=Udpmod, Inc./CN=Udpmod Root CA" -out ${dir}/UDPMOD/udpmod.ca.crt 2>/dev/null
openssl req -newkey rsa:2048 -nodes -keyout ${dir}/UDPMOD/udpmod.server.key -subj "/C=CN/ST=GD/L=SZ/O=Udpmod, Inc./CN=${domain}" -out ${dir}/UDPMOD/udpmod.server.csr 2>/dev/null
openssl x509 -req -extfile <(printf "subjectAltName=DNS:${domain},DNS:${domain}") -days 3650 -in ${dir}/UDPMOD/udpmod.server.csr -CA ${dir}/UDPMOD/udpmod.ca.crt -CAkey ${dir}/UDPMOD/udpmod.ca.key -CAcreateserial -out ${dir}/UDPMOD/udpmod.server.crt 2>/dev/null

sed -i "s/100/600/" ${dir}/UDPMOD/config.json 2>/dev/null
sed -i "s/setobfs/${OBFS}/" ${dir}/UDPMOD/config.json 2>/dev/null
sed -i "s#instDir#${dir}#g" ${dir}/UDPMOD/config.json 2>/dev/null
sed -i "s#instDir#${dir}#g" ${dir}/UDPMOD/udpmod.service 2>/dev/null
sed -i "s#iptb#${interfas}#g" ${dir}/UDPMOD/udpmod.service 2>/dev/null
sed -i "s#sysb#${sys}#g" ${dir}/UDPMOD/udpmod.service 2>/dev/null
sed -i "s#ip4tbin#${ip4t}#g" ${dir}/UDPMOD/udpmod.service 2>/dev/null
sed -i "s#ip6tbin#${ip6t}#g" ${dir}/UDPMOD/udpmod.service 2>/dev/null

mv /root/UDPMOD/udpmod.service /etc/systemd/system 2>/dev/null

sed -i 's/10000:65000/20000:39999/g' /etc/systemd/system/udpmod.service 2>/dev/null

sed -i -E "s/\"config\": ?\[[[:space:]]*\"sbg\"[[:space:]]*\]/\"config\": [$(printf "\"%s\"," "Usbg:Psbg" | sed 's/,$//')]/g" /root/UDPMOD/config.json 2>/dev/null

systemctl daemon-reload
systemctl start udpmod
systemctl enable udpmod
systemctl restart udpmod
clear
echo -e "${COLOR1}╭══════════════════════════════════════════╮${NC}"
echo -e "   \e[1;32mOBFS: ${OBFS}" > ${dir}/UDPMOD/data
echo -e "   \e[1;32mPuerto: 36712" >> ${dir}/UDPMOD/data
echo -e "   \e[1;32mRango de Puertos: 20000:39999"
echo -e "   \e[1;32mUsuario :    Usbg"
echo -e "   \e[1;32mContraseña : Psbg"
echo -e "${COLOR1}╰══════════════════════════════════════════╯${NC}"
rm -f /root/UDPMOD/install.sh
rm -f /root/UDPMOD/README.md
echo -e " \e[1;32mHYSTERIA Instalado Correctamente"
sleep 2
clear
setupudp2 2>/dev/null
