# A simple guide to Docker basic Docker commands.

This repo is designed as a friendly step-by-step introduction to building your first Dockerfile.

This starts with the image `python:alpine3.13`

- [Building a dockerfile](#building-a-dockerfile)
- [Running your container](#running-your-container)
- [Adding files](#adding-files)
- [Addding packages](#adding-packages)
- [Users](#users)
- [Entrypoints](#entrypoints)
- [Additional Reading](#additional-reading)

## Pre-reqs

- Either installed Docker and git or use the website https://labs.play-with-docker.com/#
- Clone this repository: ```console git clone https://github.com/Homopatrol/Docker_start```

### Building a Docker Image

To build a Docker **Image** you must first make sure you are in the same directory as the `Dockerfile`
```console
cd Docker_start/
```
Then perform:
```console
docker build -t <yourdockername>/<my_first_dockefile>:<revision> .
```
**You will have to rebuild your Docker image everytime you make changes to the Dockerfile.**

### Running your container 

To create a **Container** based off your newly built Docker Image run:
```console
docker run -it <yourdockername>/<my_dockefile>:<revision> sh
```
the flag `-it` is a combination of the flags `-i` and & `-t`.

| Name | shorthand | description | 
|------|-----------|-------------|
|--interactive | -i 	|	Keep STDIN open even if not attached |
|--tty | -t |	Allocate a pseudo-TTY |

The stdin stream (-i) attaches the container to the stdin of your shell while the TTY (-t)  gives you the ability to interact with the container like a traditional VM.

Now you are able to access container and perform commands, have a look around and what in your container.
```console
docker run -it <yourdockername>/<my_dockefile>:<revision> sh
/ # ls
bin    dev    etc    home   lib    media  mnt    opt    proc   root   run    sbin   srv    sys    tmp    usr    var
/ # echo "This command is being run inside a container"
This command is being run inside a container
/ # 
```

### Adding files

We may need to add additional scripts and files into our container so that we may peform various tasks.

This is achieve by using the `COPY` instruction.

`COPY \ \files` 

The first `\` is the source of the contents being copied in relation to the Dockerfile ( in this case the same Directory we are in ) and the following `\` is the destination filesystem of the container at the path. ( here we are copying the files in this repository to a directory called \files in our container)

**Note** If the `COPY` destination directory doesn’t exist, it will be created.

```console
docker run -it <yourdockername>/<my_dockefile>:<revision> sh
/ # ls
bin  files  dev    etc    home   lib    media  mnt    opt    proc   root   run    sbin   srv    sys    tmp    usr    var
/ $ ls files
Dockerfile       README.md        hello_bash.sh    hello_python.py
```

### Adding packages

Lets try adding this [practical-git-tutorial](https://github.com/johnmosesman/practical-git-tutorial) git hub repository into our container.

The `RUN` instruction will execute any commands in a new layer on top of the current image and commit the results into your Dockerfile. 

Now say we want to add files from a git repository we can now run the command `git clone https://github.com/johnmosesman/practical-git-tutorial` .... as we build our image.

```console
RUN git clone https://github.com/johnmosesman/practical-git-tutorial
```

Now if we build our image again 
```console
docker build -t <yourdockername>/<my_dockefile>:<revision> .
```
....OOPS! you should see the error.
```console
 => ERROR [3/3] RUN  git clone https://github.com/johnmosesman/practical-git-tutorial &&      chown -R 47:0 /files &&      chmod -R g=u /files                                                                                           0.3s
------
 > [3/3] RUN  git clone https://github.com/johnmosesman/practical-git-tutorial &&      chown -R 47:0 /files &&      chmod -R g=u /files:
#7 0.242 /bin/sh: git: not found

```

We cannot run the `git` when we build this image - this is because we are missing git in our container! (Remember Containers should have the minimum packages needed to perform).

Now lets install git in our container using Alpines package manager **apk**

```console
RUN apk add git && \
    git clone https://github.com/johnmosesman/practical-git-tutorial
```
You should able to successfully build your container now!

And if you *run* your Container you can now see the repository *practical-git-tutorial* has be cloned into our container.

```console
docker run -it <yourdockername>/<my_dockefile>:1 sh
/ $ ls
bin                     files                   media                   practical-git-tutorial  run                     sys                     var
dev                     home                    mnt                     proc                    sbin                    tmp
etc                     lib                     opt                     root                    srv                     usr
```

```console
/ $ cat practical-git-tutorial/chapter-1.txt 
Chapter 1 - The Beginning
It was the best of times, it was the worst of times
```

### Users

By default the Docker daemon always runs as the root user.

`/ # id
uid=0(root) gid=0(root) groups=0(root),1(bin),2(daemon),3(sys),4(adm),6(disk),10(wheel),11(floppy),20(dialout),26(tape),27(video)
`

Therefore it is best practice to create our own user and assign it the bare minimum permissions it needs to perform its task.

The `USER` instruction sets the user name (or UID) to use when running the image 

**Note** Any `RUN` `CMD` and `ENTRYPOINT` instructions that follow a `USER` instruction will be performed as that user.

We start by using the `ARG` instruction to define a variable that we contains the UID we would like to refer to our user under, in this case its up to you Agent 47.

```console
FROM ...
..
ARG UID=47

```

Then we use our `RUN` instruction to assign the USER the correct permissions for our `/files` directory so that it that it may access the scripts.

```console
RUN apk add git && \
     ...
     chown -R ${UID}:0 /files

USER 47
```
Now build your image again and run it, you should now be running the container as our user *47* and he should now be the owner of the `/files` directory.

```
/ $ id
uid=47 gid=0(root)

/ $ ls -la
total 88
drwxr-xr-x    1 root     root          4096 Jul 26 12:50 .
drwxr-xr-x    1 root     root          4096 Jul 26 12:50 ..
-rwxr-xr-x    1 root     root             0 Jul 26 12:50 .dockerenv
drwxr-xr-x    1 root     root          4096 May  4 18:35 bin
drwxr-xr-x    5 root     root           360 Jul 26 12:50 dev
drwxr-xr-x    1 root     root          4096 Jul 26 12:50 etc
drwxrwxr-x    1 47       root          4096 Jul 26 12:47 files
drwxr-xr-x    2 root     root          4096 Apr 14 10:25 home
drwxr-xr-x    1 root     root          4096 May  4 18:35 lib
drwxr-xr-x    5 root     root          4096 Apr 14 10:25 media
drwxr-xr-x    2 root     root          4096 Apr 14 10:25 mnt
drwxr-xr-x    2 root     root          4096 Apr 14 10:25 opt
drwxr-xr-x    3 root     root          4096 Jul 26 12:48 practical-git-tutorial
dr-xr-xr-x  213 root     root             0 Jul 26 12:50 proc
drwx------    1 root     root          4096 May  4 18:31 root
drwxr-xr-x    2 root     root          4096 Apr 14 10:25 run
drwxr-xr-x    1 root     root          4096 May  4 18:35 sbin
drwxr-xr-x    2 root     root          4096 Apr 14 10:25 srv
dr-xr-xr-x   13 root     root             0 Jul 26 12:50 sys
drwxrwxrwt    1 root     root          4096 Jun 29 01:38 tmp
drwxr-xr-x    1 root     root          4096 Jul 26 12:48 usr
drwxr-xr-x    1 root     root          4096 Jul 26 12:48 var

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

**Note** Because the container user is always a member of the *root* group (unless specified otherwise), the container user can read and write these files.

### Entrypoints

Now lets use an EntryPoint so our container will run as an executable performing the script `hello_python.py` each time it is run.

Entrypoints take the command `"executable param1 param2"` and are written as:

ENTRYPOINT ["executable", "param1", "param2"]

Therefore if we want to run the script `hello_python.py` using the full command`"python hello_python.py"` we must write this as:

```
ENTRYPOINT ["python", "hello_python.py"]
```

> BUT WAIT ISN'T "hello_python.py" INSIDE THE /files directory

Ah yes you beat me to it! let's use the `WORKDIR` instruction to set the working directory for this instruction.

**Note** Any `RUN` `CMD` `COPY` and `ADD` instructions that follow this `WORKDIR` in the Dockerfile will also be executed under `/files`

```console
WORKDIR files/
```

**Note** The `WORKDIR` instruction can be used multiple times, if the `WORKDIR` doesn’t exist, it will be created even if it’s not used in any subsequent Dockerfile instruction.

Now if you build you image again and try to run it you should now see the output of the "hello_python.py" script.

```console
docker run -it <yourdockername>/<my_dockefile>:<revision>
Hello, this script is running in your Dockerfile!
```

If you wish to access your container again you must add the additonal `--entrypoint` flag to overwrite the ENTRYPOINT.

Your run command now looks like:

```console
 docker run -it --entrypoint sh <yourdockername>/<my_dockefile>:<revision>
/files $ ls 
Dockerfile       README.md        hello_bash.sh    hello_python.py
```

Notice how our container started in `/files` this time because of our `WORKDIR` instruction ;)

## Additional Reading
- https://training.play-with-docker.com/alacart/
- https://docs.docker.com/get-started/overview/
- https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
- https://docs.docker.com/language/
- https://docs.docker.com/engine/reference/builder/
- https://docs.openshift.com/container-platform/4.7/openshift_images/create-images.html
