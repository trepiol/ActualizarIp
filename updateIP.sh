#!/bin/bash
#script para actualizar la direccion ip con el dominio de noip


#credenciales

#cargo las variables con las credenciales

source .env

noip_user="$user"
noip_pass="$pass"
noip_host="$host"
user_agent="agent"
url_noip="https://dynupdate.no-ip.com/nic/update"
archivoLog="$Log"

#obtener ip de la instancia de aws
ip=$(curl ifconfig.me)

#generar la solicitud a noip y realizar la actualizacion para la nueva ip
solicitud=$(curl -s -u "$noip_user:$noip_pass" \
  -A "$user_agent" \
  "$url_noip?hostname=$noip_host&myip=$ip")

# registrar los eventos en el archivos de registros
echo "$(date): $solicitud" >> "$archivoLog"

#interceptar la respuesta
case "$solicitud" in
        good*)
                echo "IP actualizada correctamente"
                ;;
        nochg*)
                echo "La IP $ip ya esta actualizada"
                ;;
        *)
                echo "Error al actualizar la ip: $solicitud"
                ;;
esac

