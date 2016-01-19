# Entorno de desarrollo/producción mediante el uso de Vagrant y Ansible

**Aviso**: Está probado en una Ubuntu 14.04 LTS como sistema operativo.

## APLICACIONES
Instala lo siguiente:

- NGINX
- PHP
- COMPOSER

## PREPARACIÓN DEL ENTORNO
Instalar vagrant, virtualbox y ansible:

``` bash
$ sudo apt-add-repository ppa:ansible/ansible
$ sudo apt-get update
$ sudo apt-get virtualbox
$ sudo apt-get vagrant
$ sudo apt-get ansible
```

## CLONADO DEL PROYECTO
Cada cual clonará el proyecto donde mejor le convenga, para este tutorial será en _~/Projects/Provision/Basic_

## CREACIÓN DE CLAVES
Para poder usar _ansible_ deberemos crear dos claves ssh, una para desarrollo y otra para producción.

``` bash
$ ssh-keygen -t rsa -C "correo@electronico.com"
```
Ejecutar el anterior comando una vez dándole a la clave el nombre _dev_ y _pro_ la segunda vez.

Tras la creación se deben copiar **ambas claves públicas** (.pub) en el directorio _common/keys_

Estas claves se copiarán automáticamente en la _box_ _dev_ una vez se inicie.

## ACTIVAR LAS CLAVES
Para que nuestra máquina _host_ se pueda comunicar con las _boxes_ usando las claves que acabamos de crear debemos:

``` bash
$ ssh-agent bash
$ ssh-add ~/.ssh/dev
$ ssh-add ~/.ssh/pro
```

## INICIAR LAS MÁQUINAS VIRTUALES
``` bash
~/Projects/Provision/Basic/box$ vagrant up
```

## PROBANDO LA COMUNICACIÓN CON ANSIBLE
Para comprobar que _ansible_ puede acceder a la _box_ _dev_ ejecutaremos:

``` bash
~/Projects/Provision/Basic$ ansible server -i provision/environments/dev/dev -m ping
```

Debiéndonos devolver lo siguiente:

```
10.10.10.10.10 | success >> {
    "changed": false,
    "ping": "pong"
}
```

Usamos _server_ puesto que está creado un _group_ con ese nombre para especificar el host tanto de _dev_ como _pro_.
Ver archivos _provision/environments/pro/pro_ y _provision/environments/dev/dev_.

## CONFIGURACIÓN DEL SERVIDOR MEDIANTE ANSIBLE
Para aprovisionar *dev* ejecutaremos:

``` bash
~/Projects/Provision/Basic$ ansible-playbook -i provision/environments/dev/dev provision/dev.yml
```

## NGINX, PHP-FPM Y COMPOSER
Mediante ansible se instala _nginx_, _php-fpm_ y _composer_. En _provision/environments/dev/groups_vars_ se puede ver los parámetros
configurables de cada uno de estos roles.

## USAR UN SERVIDOR EXTERNO COMO PRODUCCIÓN
Modificamos el archivo _provision/environments/pro/pro_ especificando la IP del servidor externo.

### PROBANDO LA COMUNICACIÓN CON ANSIBLE
``` bash
~/Projects/Provision/Basic$ ansible server -i provision/environments/pro/pro -m ping
```

Debiéndonos devolver lo siguiente:

```
<IP> | success >> {
    "changed": false,
    "ping": "pong"
}
```
## CONFIGURACIÓN DEL SERVIDOR MEDIANTE ANSIBLE
Para aprovisionar *dev* ejecutaremos:

``` bash
~/Projects/Provision/Basic$ ansible-playbook -i provision/environments/pro/pro provision/pro.yml
```

## AGRADECIMIENTOS
- http://phansible.com/
- http://future500.nl/articles/2014/05/how-to-use-ansible-for-vagrant-and-production/
- http://www.erikaheidi.com/blog/configuring-a-multistage-environment-with-ansible-and-vagrant
- https://serversforhackers.com/an-ansible-tutorial