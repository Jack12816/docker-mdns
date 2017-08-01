![Docker mDNS Demo](docs/assets/project.png)

This prototype is dedicated to demonstrate the setup of Docker containers which
are accessible by mDNS addresses. The regular ZeroConf TLD is `.local`.  So
with the help of this demo you can learn how to setup a new container and make
it available as [nginx.local](http://nginx.local).

## Requirements

* [Docker](https://www.docker.com/community-edition) (>=17.06.0-ce) (lower should work, too)
* [Docker Compose](https://docs.docker.com/compose/install/) (>=1.15.0) (lower should work, too)
* [GNU Make](https://www.gnu.org/software/make/) (>=4.2.1)
* [jq](https://stedolan.github.io/jq/download/) (>=1.5)
* Host enabled Avahi daemon
* Host enabled mDNS NSS lookup

## Getting started

All you need to to is to run the following command:

```bash
$ make start
```

This command will take care of downloading the `nginx:latest` docker image and
building the custom image on top of it. Afterwards the new image will be
booted.

Start a second terminal and type the following command to verify your host
configuration:

```bash
$ make test
```

If everything is fine, you will see something like this:

```bash
# Test the IP/mDNS setup
#
# > Container ip: 172.17.0.2
#
# DNS resolution test (nginx.local):
PING nginx.local (172.17.0.2) 56(84) bytes of data.
64 bytes from 172.17.0.2 (172.17.0.2): icmp_seq=1 ttl=64 time=0.062 ms
64 bytes from 172.17.0.2 (172.17.0.2): icmp_seq=2 ttl=64 time=0.053 ms
64 bytes from 172.17.0.2 (172.17.0.2): icmp_seq=3 ttl=64 time=0.102 ms
64 bytes from 172.17.0.2 (172.17.0.2): icmp_seq=4 ttl=64 time=0.079 ms

--- nginx.local ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3034ms
rtt min/avg/max/mdev = 0.053/0.074/0.102/0.018 ms
#
# Test was successful. Yay.
```

If the test fails, read on.

## Host configs

Install the nss-mdns package, enable and start the avahi-daemon.service. Then,
edit the file /etc/nsswitch.conf and change the hosts line like this:

```bash
hosts: ... mdns4_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] dns ...
```

## Further reading

* Archlinux howto: https://wiki.archlinux.org/index.php/avahi
* Ubuntu/Debian howto: https://wiki.ubuntuusers.de/Avahi/
