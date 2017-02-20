2017-02-20
----------

rosserial
arduino

=> partage des builds (images docker), des volumes (ros, catkin)

Questions ?
- Comment on gère le build des images et la spécification des tags, options, etc ... ?
=> peut être utiliser un script python (plus intelligent qu'un .sh) qui pourrait prendre en compte
un fichier de settings (.yaml ou .json) pour builder des images.
Il pourrait chercher dans le répertoire courant de construction de l'image, la présence d'un fichier de config
et l'utiliser le cas échéant (ou utiliser des options par défaut, définies par l'application/script)


rosserial:arduino:

Hérite de ros:indigo (core, base, ...)

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