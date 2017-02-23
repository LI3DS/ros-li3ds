[![asciicast](https://asciinema.org/a/7xl3e22hk6atsrw7q8gpuouek.png)](https://asciinema.org/a/7xl3e22hk6atsrw7q8gpuouek)

2017-02-20
----------

rosserial
arduino

=> partage des builds (images docker), des volumes (ros, catkin)

Questions ?
----------
- Comment on gère le build des images et la spécification des tags, options, etc ... ?
=> peut être utiliser un script python (plus intelligent qu'un .sh) qui pourrait prendre en compte

un fichier de settings (.yaml ou .json) pour builder des images. Il pourrait chercher dans le répertoire courant de construction de l'image, la présence d'un fichier de config
et l'utiliser le cas échéant (ou utiliser des options par défaut, définies par l'application/script)

rosserial:arduino: Hérite de ros:indigo (core, base, ...)

---------------------------------------------------------------------------

1. Compiler et uploader un projet arduino (scripts)
	- les sources/scripts (ino, .h)
	- cmake
		- toolchain arduinocmake
		- url: https://cmake.org/files/
2. INS: Ellipse-N
	- Docker
	- outils de compilation: build-essential
		- http://askubuntu.com/questions/152653/cmake-fails-with-cmake-error-your-cxx-compiler-cmake-cxx-compiler-notfound
	- cmake > 3.x
		- http://askubuntu.com/questions/610291/how-to-install-cmake-3-2-on-ubuntu-14-04
		- https://cmake.org/files/

=> Maitriser wstool, rosdep, .rosinstall, etc ...
Pour gérer la gestion des dépendances des packages (customs) ROS.
urls:
- http://wiki.ros.org/roslocate
- http://wiki.ros.org/rosinstall
- http://answers.ros.org/question/74404/rosdep-how-to-define-dependency-management-on-custom-package/
- http://wiki.ros.org/rosinstall_generator
- http://answers.ros.org/question/194763/resolving-package-dependencies-in-a-catkin-ws/
- http://wiki.ros.org/fr/ROS/Tutorials/NavigatingTheFilesystem


http://stackoverflow.com/questions/37933204/building-common-dependencies-with-docker-compose

```
Use a Makefile. docker-compose is not designed to build chains of images, it's designed for running containers.
```


2017-02-21:
----------

INS
---
1. Creation de volume: li3ds_ins_overlay_ws
2. Build de l'image: li3ds/ins:latest

!!!! Il faut que la var env ROS_CATKIN_WS soit set !!!!
```bash
# echo $ROS_CATKIN_WS/
/catkin_ws/

(rm -r overlay_ws)
source entry-point.sh
source ./scripts/create_overlay_ws.sh
source ./scripts/get_and_build_with_catkin.sh [potentiellement x2]
launch_roslaunch_on_ellipse_n.sh
```

2017-02-23:
----------

Laser
-----

- il faut régler l'ip du laser (serveur HTTP du laser)
- désactiver le proxy pour cette adresse (à vérifier)
- lancer le node ros du VLP-16: 'launch_server_ros_vlp-16.sh'

```bash
export VLP16_NETWORK_SENSOR_IP=172.20.0.191
source entry-point.sh
source scripts/source_install.sh
export no_proxy="*"
roslaunch velodyne_pointcloud VLP16_points.launch &
```

Problème majeur
---------------
Transmission des packets UDP (data) par les ports (2368 par défaut)

urls:
----
- https://www.google.fr/search?client=ubuntu&channel=fs&q=docker-compose+upd+network&ie=utf-8&oe=utf-8&gfe_rd=cr&ei=w_iuWLyUApTu8wfkkI_YBA#channel=fs&q=docker-compose+network+udp+from+outside
- Bind container ports to the host -> https://docs.docker.com/engine/userguide/networking/default_network/binding/
- Difference between “expose” and “publish” in docker: http://stackoverflow.com/questions/22111060/difference-between-expose-and-publish-in-docker
- udp port assignment ignored #1334 -> https://github.com/docker/compose/issues/1334

Solution:
--------
Dans docker-compose.yml, au niveau de la définition du node 'ros_li3ds_laser':
ports:
```
	"2368:2368/udp"
```

-> map les ports udp 2368 entre localhost et le container.

On peut vérifier l'établissement de la règle d'iptable:
```
┏ ✓    latty@MAC1201W008-LINUX   ~/link_dir/Docker/2017_LI3DS     0.81   0.25G    16:28:28 
┗ sudo iptables -L -n -t nat | grep 2368        
MASQUERADE  udp  --  172.18.0.4           172.18.0.4           udp dpt:2368
DNAT       udp  --  0.0.0.0/0            0.0.0.0/0            udp dpt:2368 to:172.18.0.4:2368
```
(après le lancement des containers -> 'docker-compose up')
(on peut rajouter le port de télémétrie: 8308 (par défaut))

Faudra surement ouvrir des ports (coté Dockerfile avec EXPOSE) pour la communication et le setting du web serveur vélodyne (surement le port 80 (ou 8080)).


---------------------------------------------------------------------------

Mapping des devices (USB) dans docker (docker-compose)
------------------------------------------------------

Deux versions pour mapper les périphériques/devices USB/ACM
1. Soit une version ciblée précisement sur un filepath particulier
```
devices:
	- "/dev/ttyACM0:/dev/ttyACM0"
```
2. Une version plus généraliste (et permissive),
on transmet tous les devices disponibles de l'host au container
```
    privileged: true
    volumes:
      - "/dev/bus/usb:/dev/bus/usb"
```

Si on utilise la solution 1., il faut (mieux) passer par des règles
d'attribution de filepath aux devices via des udev rules
-> voir [2017 - LINUX - USB devices (Arduino) finding, associating, etc ...](https://docs.google.com/document/d/1-pBXbnUNzUmnedP8WQysDRGHMco5L_GiBVGlq_oeYp4/edit?usp=sharing)
