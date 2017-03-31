### airgeddon project
This is the official embedded airgeddon script docker image based on Kali Linux.

![Banner](https://raw.githubusercontent.com/v1s1t0r1sh3r3/airgeddon/master/imgs/banners/airgeddon_banner.png)

Dockerfile is available at [airgeddon Github project](https://github.com/v1s1t0r1sh3r3/airgeddon) also. Direct link to [Dockerfile](https://github.com/v1s1t0r1sh3r3/airgeddon/blob/docker/docker/Dockerfile).

---

### How to run it
To run a container based on this Docker image, bear in mind that it should be run on a system running X Window because it runs xterm windows used for some features.

Below, there is a docker run command as example. The image is going to be automatically downloaded from Dockerhub and then a Docker container is going to be run. It will launch airgeddon script automatically inside the container:

```
docker run --rm -ti --name airgeddon --net=host --privileged -p 3000:3000 -v /path/to/some/dir/on/your/host:/io v1s1t0r1sh3r3/airgeddon
```

Parameters explanation:

`--rm` -> Ephemeral containter. It will be removed on exit.
`-ti` -> Attach pseudo-TTY terminal to the container as interactive.
`--name airgeddon` -> Name for the container.
`--net=host` -> Is needed to access to the host network interfaces.
`--privileged` -> Needed to have permissions over wireless interfaces.
`-p 3000:3000` -> Open port to access to BeEF control panel from the host.
`-v /path/to/some/dir/on/your/host:/io` -> It maps a directory from host to the container. Useful to use external files like dictionaries or whatever.

Don't forget to replace "/path/to/some/dir/on/your/host" with a path of an existing directory of your choice on your host machine. That directory will be the "input/output" point for the script. For example, if you place a dictionary.txt file there, inside the script you must access to it as "/io/dictionary.txt".

![Docker Banner](https://raw.githubusercontent.com/v1s1t0r1sh3r3/airgeddon/docker/imgs/banners/airgeddon_docker.png)

---

### License
This Docker image is under GPLv3+ license.

![Gpl](http://gplv3.fsf.org/gplv3-127x51.png)