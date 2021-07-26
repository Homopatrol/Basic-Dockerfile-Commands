# A simple Docker guide

This repo is designed for a friendly step by step introduction to building your first Docker container.

This starts with the image `python:alpine3.13`

- [Building a dockerfile](#building-a-dockerfile)
- [Running your container](#running-your-container)
- [Adding files](#adding-files)
- [Addding packages](#adding-packages)
- [Users](#users)
- [Entrypoints](#entrypoints)

## Pre-reqs

- Install Docker and git 
- clone this repository ```console git clone https://github.com/Homopatrol/Docker_start```

### Building a Docker Image

To build a Docker **Image** make sure you are in the same directory as the `Dockerfile`
```console
cd Docker_start/
```
And perform:
```console
docker build -t <yourdockername>/<my_dockefile>:1 .
```

### Running your container 

To create a **Container** based off your newly built Docker Image run:
```console
docker run -it <yourdockername>/<my_dockefile>:1 sh
```
the flag `-it` is a combination of the flags `-i` and & `-t`.

| Name | shorthand | description | 
|------|-----------|-------------|
|--interactive | -i 	|	Keep STDIN open even if not attached |
|--tty | -t |	Allocate a pseudo-TTY |

The stdin stream (-i) attaches the container to the stdin of your shell while the TTY (-t)  gives you the ability to interact with the container like a traditional VM.

```console
docker run -it  pandoraholladay/test:1 sh
/ # ls
bin    dev    etc    home   lib    media  mnt    opt    proc   root   run    sbin   srv    sys    tmp    usr    var
/ # echo "This command is being run inside a container"
This command is being run inside a container
/ # 
```
### Adding files

`COPY \ \files` 
The first `\` signifies the location of the contents being copied in relation to the Dockerfile ( in this case the same Directory ) and the following `\` is where they should be copied to in the Dockerfile.

```console
docker run -it  pandoraholladay/test:1 sh
/ # ls
bin  files  dev    etc    home   lib    media  mnt    opt    proc   root   run    sbin   srv    sys    tmp    usr    var
/ $ ls files
Dockerfile       README.md        hello_bash.sh    hello_python.py
```

### Adding packages

Notice how you cannot run the `xxx` script in this container? - this is because we are missing xxx on our dockerfile! ( Remeber Dockerfile should be built with the minimum packages needed) 

So lets try adding the command git to our Dockerfile 

`RUN apk add git` 

`RUN` will execute any commands in a new layer on top of the current image and commit the results into your Dockerfile. 

Now say we want to add files from a git repository we can now run the command git clone .... as we build our image.

### Users

The Docker daemon always runs as the root user.

`/ # id
uid=0(root) gid=0(root) groups=0(root),1(bin),2(daemon),3(sys),4(adm),6(disk),10(wheel),11(floppy),20(dialout),26(tape),27(video)
`
Therefore it is best practice to create our own user and assign it the bare minimum permissions it needs to run.
```
FROM ...
..
ARG UID=47
ARG GID=47
RUN chown -R ${UID}:0 /files && \
     chmod -R g=u /files

USER 47
```
```
/ $ id
uid=47 gid=0(root)

/ $ ls -la files
total 36
drwxrwxr-x    1 47       root          4096 Jul 26 12:32 .
drwxr-xr-x    1 root     root          4096 Jul 26 12:33 ..
drwxrwxr-x    1 47       root          4096 Jul 26 11:43 .git
-rw-rw-r--    1 47       root           319 Jul 26 12:32 Dockerfile
-rw-rw-r--    1 47       root          1419 Jul 26 11:39 README.md
-rw-rw-r--    1 47       root           365 Jul 26 12:11 hello_bash.sh
-rw-rw-r--    1 47       root            59 Jul 26 11:39 hello_python.py
```

### Entrypoints

```
WORKDIR files/
ENTRYPOINT ["python", "hello_python.py"]
```

```console
docker run -it  pandoraholladay/test:1  
Hello, this script is running in your Dockerfile!
```
