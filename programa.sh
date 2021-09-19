#!/bin/bash
# Bautista Garcia Pedro
# Proyecto utilerias

echo "*********************************************************************************"
echo "*** P R O G R A M A:  C O N T R O L  D E  U S U A R I O S  Y  P R O C E S O S ***"
echo "*********************************************************************************\n"

echo "-El usuario: $(whoami) Terminal: $(tty) Ejecuto el programa en la fecha epoch: $(date +%s) Fecha estandar: $(date) \n" >> bitacora.log

manejoDeArchivos(){
	echo "\n\n\tM A N E J O  D E  A R C H I V O S\n"
	local opcion=0	
	while [ "$opcion" != 3 ] 
	do
		read -p "Nombre del archivo que deseas buscar: " archivo
		if [ $(find $archivo 2>> errores.log | wc -l) = 1 ]
		then
			nombreArchivo=$(find $archivo | rev | cut -f1 -d/ | rev)
			echo "Nombre de Archivo: $nombreArchivo"
			numInodo=$(ls -ldi $nombreArchivo | cut -f1 -d" ")
			echo "Numero de i-nodo: $numInodo"
			tipoArchivo=$(ls -ld $nombreArchivo | cut -f1 -d" " | cut -c1)
			if [ "$tipoArchivo" = '-' ]
			then
				echo "Tipo de archivo: ordinario"
			elif [ "$tipoArchivo" = 'l' ]
			then
				echo "Tipo de archivo: liga simbolica"
			elif [ "$tipoArchivo" = 'd' ]
			then
				echo "Tipo de archivo: directorio"
			else
				echo "Tipo de archivo: otro"
			fi
			numLigasDuras=$(ls -ld $nombreArchivo | cut -f2 -d" ")
			echo "Numero de ligas duras: $numLigasDuras"
			dueno=$(ls -ld $nombreArchivo | cut -f3 -d" ")
			echo "Dueno: $dueno"
			grupo=$(ls -ld $nombreArchivo | cut -f4 -d" ")
			echo "Grupo: $grupo"
			tamanoBytes=$(ls -ld $nombreArchivo | cut -f5 -d" ")
			echo "Tamano en bytes: $tamanoBytes"
			echo "Marcas de tiempo"
			atime=$(ls -lud $nombreArchivo | cut -f6,7,8 -d" ")
			echo "Fecha de ultimo acceso: $atime"
			mtime=$(ls -l $nombreArchivo | cut -f6,7,8 -d" ")
			echo "Fecha de ultima modificacion: $mtime"
			ctime=$(ls -lcd $nombreArchivo | cut -f6,7,8 -d" ")
			echo "Fecha de ultima modificacion del i-nodo: $ctime"
			echo "Permisos"
			plectura=$(ls -ld $nombreArchivo | cut -f1 -d" " | cut -c2 | grep r && echo lectura || echo "")
			pescritura=$(ls -ld $nombreArchivo | cut -f1 -d" " | cut -c3 | grep w && echo escritura || echo "")
			pejecucion=$(ls -ld $nombreArchivo | cut -f1 -d" " | cut -c4 | grep x && echo ejecucion || echo "")
			echo "Para el usuario: $(echo $plectura | cut -f2 -d" "), $(echo $pescritura | cut -f2 -d" "), $(echo $pejecucion | cut -f2 -d" ")"
			pLectura=$(ls -ld $nombreArchivo | cut -f1 -d" " | cut -c5 | grep r && echo lectura || echo "")
			pescritura=$(ls -ld $nombreArchivo | cut -f1 -d" " | cut -c6 | grep w && echo escritura || echo "")
			pejecucion=$(ls -ld $nombreArchivo | cut -f1 -d" " | cut -c7 | grep x && echo ejecucion || echo "")
			echo "Para el grupo: $(echo $plectura | cut -f2 -d" "), $(echo $pescritura | cut -f2 -d" "), $(echo $pejecucion | cut -f2 -d" ")"
			pLectura=$(ls -ld $nombreArchivo | cut -f1 -d" " | cut -c8 | grep r && echo lectura || echo "")
			pescritura=$(ls -ld $nombreArchivo | cut -f1 -d" " | cut -c9 | grep w && echo escritura || echo "")
			pejecucion=$(ls -ld $nombreArchivo | cut -f1 -d" " | cut -c10 | grep x && echo ejecucion || echo "")
			echo "Para otros: $(echo $plectura | cut -f2 -d" "), $(echo $pescritura | cut -f2 -d" "), $(echo $pejecucion | cut -f2 -d" ")"		 

			#opciones internas
			echo "\n OPCIONES PAR REALIZAR SOBRE EL ARCHIVO"
			echo "1 = Modificar los permisos del archivo (modo octal)"
			echo "2 = Borrar el archivo"
			echo "3 = Regresar al menu principal\n"
			read -p "Elige una opcion(#): " opcion
			case "$opcion" in
				1) 
					read -p "Ingresa el modo octal (###): " modoOctal ;
					if [ $(echo $modoOctal | grep '[0-7][0-7][0-7]' | wc -l) -eq 1 ]
					then
						chmod $modoOctal $archivo 2>> errores.log | echo "Permisos aplicados con exito\n";
					else
						echo "¡Modo octal incorrecto! Ingresa un formato valido\n"
					fi ;;
				2) 
					read -p "Estas seguro que deseas eliminar el archivo $nombreArchivo ? (y/n): " respuesta;
					if [ $(echo $respuesta | grep '[Yy]' | wc -l) -eq 1 ]
					then
						rm -r $archivo 2>> errores.log | echo "$nombreArchivo fue eliminado con exito\n";
					else
						echo "NO se elimino elimino ningun archivo, vuelve a intentarlo\n"
					fi
					;;
				3) 
					echo "Regresando al menu principal...\n" ;;
				*) 
					echo "\n no existe, ingresa una opcion valida!\n" ;;
			esac
		else
			opcion=0
			echo "¡EL ARCHIVO NO EXISTE!\n"
		fi
	done
}

manejoDeProcesos(){
	echo "\n\n\tM A N E J O  D E  P R O C E S O S\n"
	local opcion=0
	while [ "$opcion" != 5 ] 
	do	
		echo "\n\t 1 = Listar la tabla de procesos (por paginas)" 
		echo "\t 2 = Listar la tabla de procesos de un usuario especifico"
		echo "\t 3 = Matar un proceso"
		echo "\t 4 = Numero de procesos totales corriendo en el sistema"
		echo "\t 5 = Regresar al menu principal\n"
		read -p "Elige una opcion (#): " opcion
		case "$opcion" in
			1) 
				echo "\tTabla de procesos";
				echo "Para avanzar a la siguiente pagina presiona la barra espaciadora";
				echo "Para finalizar presiona la tecla Q\n";
				ps -fe | more
				;;
			2)  
				read -p "Ingresa el nombre del usuario: " nombreUsuario
				if [ $(cut -f1 -d: /etc/passwd | grep $nombreUsuario | wc -l) -eq 1 ]
				then
					if [ $(ps -u $nombreUsuario | wc -l) -gt 1 ]
					then
						echo "Procesos del usuario $nombreUsuario"
						ps -u $nombreUsuario 2>> errores.log
					else
						echo "El usuario $nombreUsuario no tiene nigun proceso en el sistema"
					fi
				else
					echo "El usuario $nombreUsuario no exite"
				fi
				;;
			3)
				read -p "Ingresa el PID del proceso que deseas matar(#): " pid
				if [ $(ps -fe | tr -s " " " " | cut -f2 -d" " | grep $pid | wc -l) -eq 1 ]
				then
					kill -9 $pid 2>> errores.log
					echo "Proceso finalizado correctamente"
				else
					echo "El proceso con PID=$pid no existe"
				fi
				;;
			4) 
				numProc=$(ps -fe | tail -n +2 | wc -l)
				echo "Numero de procesos totales en el sistema: $numProc"
				;;
			5) 
				echo "Regresando al menu principal...\n" ;;
			*) 
				echo "\n $opcion no existe, ingresa una opcion valida!";;
		esac

	done
}

monitoreoDeUsuarios(){
	echo "\n\n\tM O N I T O R E O  D E  U S U A R I O S\n"
	local opcion=0
	while [ "$opcion" != 1 ] 
	do
		read -p "Ingresa el login o UID del usuario: " usuario
		if [ $(cut -f1,3 -d: /etc/passwd | grep $usuario | sed -n '1p' | wc -l) -eq 1 ]
		then
			echo "\n1. Información del usuario"
			login=$(cut -f1,3 -d: /etc/passwd | grep $usuario | sed -n '1p' | cut -f1 -d:)
			echo "\tLogin: $login"
			uid=$(grep $login /etc/passwd | cut -f3 -d:)
			echo "\tUID: $uid"
			grupo=$(grep $login /etc/passwd | cut -f4 -d: | head -1)
			echo "\tGrupo: $(grep $grupo /etc/group | sed -n '1p' | cut -f1 -d:)"
			echo "\tNombre: $(grep $login /etc/passwd| cut -f5 -d:)"
			echo "\tHOME: $(grep $login /etc/passwd| cut -f6 -d:)"
			echo "\tSHELL: $(grep $login /etc/passwd| cut -f7 -d:)"
			echo "2. Numero total de usuarios que existen en el sistema $(wc -l /etc/passwd | cut -f1 -d" ")"
			echo "3. Numero total de grupos que existen en el sistema $(wc -l /etc/group | cut -f1 -d" ")"
			echo "4. Numero y lista de los logines de usuarios conectados al sistema"
			echo " Numero de logines: $(finger 2>> errores.log | tail -n +2 | wc -l)"
			echo " Lista de logines:"
			echo "$(finger 2>> errores.log | tail -n +2 | tr -s " " " " | cut -f1 -d" ")"
			echo "5. Numero y lista de los logines de usuarios que estan ejecutando procesos en el sistema"
			echo " Numero de logines: $(ps -fe | tr -s " " " " | cut -f1 -d" " | sort | uniq | tail -n +2 | wc -l)"
			echo " Lista de logines:"
			echo "$(ps -fe | tr -s " " " " | cut -f1 -d" " | sort | uniq | tail -n +2)"

			#regresar al menu principal
			read -p "Presiona ENTER para regresar al menu principal: " opcion
			opcion=1
		else
			echo "¡El usuario no existe! vuelve a intentarlo"		
		fi
	done
}

informacionDelSistema(){
	echo "\n\n\tI N F O R M A C I O N  D E L  S I S T E M A\n"
	echo "Hostname: $(hostname)"
	echo "Sistema operativo: $(hostnamectl 2>> errores.log | sed -n '/Operating System/p' | cut -f2 -d: | sed 's/^[[:space:]]*//g')"
	echo "Arquitectura del sistema: $(uname -i)"
	read -p "Presiona ENTER para regresar al menu principal: " salir
}

opcion=0
while [ "$opcion" != 5 ] 
do
	echo "\tM E N U  P R I N C I P A L\n"
	echo "\t 1 = MANEJO DE ARCHIVOS "
	echo "\t 2 = MANEJO DE PROCESOS"
	echo "\t 3 = MONITOREO DE USUARIOS"
	echo "\t 4 = INFORMACION DEL SISTEMA"
	echo "\t 5 = SALIR :(\n"
	read -p "Elige una opcion (#): " opcion
	case "$opcion" in
		1) 
			manejoDeArchivos ;;
		2) 
			manejoDeProcesos ;;
		3) 			
			monitoreoDeUsuarios ;;
		4) 
			informacionDelSistema ;;
		5) 
			echo "Fin del programa"; exit 0 ;;
		*) 
			echo "\n $opcion no existe, ingresa una opcion valida!";;
	esac
	
	echo "\n"

done
