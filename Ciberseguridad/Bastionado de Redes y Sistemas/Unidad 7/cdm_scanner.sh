#!/bin/bash

# Colores
inicioVerde="\e[0;32m\033[1m"
inicioRojo="\e[0;31m\033[1m"
inicioAzul="\e[0;34m\033[1m"
inicioAmarillo="\e[0;33m\033[1m"
inicioPurpura="\e[0;35m\033[1m"
inicioTurquesa="\e[0;36m\033[1m"
inicioGris="\e[0;37m\033[1m"
finColor="\033[0m\e[0m"

# Nombre del script con iniciales del usuario
NOMBRE_SCRIPT="cdm_scanner.sh"

# Verificar si se ejecuta como root
if [ $(id -u) -ne 0 ]; then
  echo -e "${inicioRojo} ERROR! ${finColor} Este script debe ejecutarse como root. Para ello, use sudo."
  echo "Ejemplo: sudo ./$NOMBRE_SCRIPT"
  exit 1
fi


# Solicitar octetos de la red local
echo -e "Ingrese los octetos de la red local (${inicioVerde} 192.168.22. ${finColor} incluyendo el punto al final):"
read -p "Red local: " RED_LOCAL

# Limpiar pantalla
clear

# Archivo para guardar las direcciones IP detectadas
IPS_FILE="ips_detectadas.txt"

# Vaciamos el archivo para agregar las nuevas Ips
> $IPS_FILE


# Mostrar direcciones IP disponibles en la red y guardarlas en un archivo
echo -e "${inicioAmarillo} Direcciones IP disponibles en la red: ${finColor}"

for i in {1..254}; do
  # Verificar si la dirección IP está disponible
  if ping -c 1 -W 0.1 $RED_LOCAL$i >/dev/null; then
    echo -n "." # Imprime un punto
    echo "$RED_LOCAL$i" >> $IPS_FILE
    else
    echo -n "."
  fi
done  


# Mostrar las direcciones IP guardadas en el archivo
echo -e "\n${inicioAzul}Direcciones IP detectadas y guardadas en $IPS_FILE:${finColor}"
cat $IPS_FILE

# Dejo un espacio para mejorar la visualización del script
echo ""

# Verificar si nmap está instalado
if [ ! -f /usr/bin/nmap ]; then
  echo -e "$inicioRojo ERROR! No se encontró la aplicación/herramienta nmap en el sistema.$finColor"
  echo -e "$inicioVerde Por favor, instálela con el comando sudo apt install nmap $finColor"
  exit 1
else
  echo -e "$inicioVerde Nmap está instalado en el sistema.$finColor"
fi

# Dejo un espacio para mejorar la visualización del script
echo ""

# Detectar y mostrar direcciones IP válidas
echo -e "${inicioPurpura} Lista de direcciones IP, sistema operativo, puertos y protocolos: ${finColor} "
IP_VALIDAS=0
# buscamos desde la ip 1 hasta la 254
for i in {1..254}; do


# buscmos mediante icmp(ping)
  PING_RESULTADO=$(ping -c 1 -W 0.1 $RED_LOCAL$i | grep ttl)
  if [ -n "$PING_RESULTADO" ]; then
    TTL=$(echo $PING_RESULTADO | cut -d' ' -f 6 | cut -d= -f 2)
    SISTEMA_OPERATIVO=""
    # Buscamos sistemas operativos Linux
    # En sistemas basados en Linux, el valor TTL predeterminado suele ser 64
    # Es decir entre 60-70 Linux
    if [ $TTL -gt 60 -a $TTL -lt 70 ]; then
      SISTEMA_OPERATIVO="Linux"
    # Buscamos sistemas operativos Windows
    # En sistemas basados en Windows, el valor TTL predeterminado suele ser 128
    # Es decir entre 120-130 Windows 
    elif [ $TTL -gt 120 -a $TTL -lt 130 ]; then
      SISTEMA_OPERATIVO="Windows"
    else
      SISTEMA_OPERATIVO="Desconocido"
    fi
    # Escaneo de puertos con nmap para obtener puertos y protocolos
    # -Pn para quitar el host discovery
    # +\/[a-z]+\s+open
    # -p- muestra los puertos
    # -sS scaneo stealh 
    # -n no realiza resolucion DNS
    NMAP_RESULTADO=$(nmap -p- -sS -Pn $RED_LOCAL$i | grep -E "^[0-9]++\/[a-z]+\s+open" )
    PUERTOS_PROTOCOLOS=""
    if [ -n "$NMAP_RESULTADO" ]; then
      PUERTOS_PROTOCOLOS=$NMAP_RESULTADO
    fi

    # Para dividir de forma visual la red, el sistema y los puertos/protocolos
    echo "###############################################"
    echo -e "####### $inicioVerde  $RED_LOCAL$i $finColor ##############"
    echo -e "$inicioTurquesa Sistema Operativo = $SISTEMA_OPERATIVO $finColor"
    echo "############################"
    echo -e "$inicioRojo Puertos y protocolos: $finColor"
    echo "$PUERTOS_PROTOCOLOS"
    IP_VALIDAS=$((IP_VALIDAS+1))
   fi
  done

# Si no se detectan IPs válidas, mostrar mensaje
if [ $IP_VALIDAS -eq 0 ]; then
  echo "No se detectaron direcciones IP válidas en la red local."
  exit 1
fi


exit 0
