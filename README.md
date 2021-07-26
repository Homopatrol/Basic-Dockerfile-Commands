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

`COPY \ \` 
The first `\` signifies the location of the contents being copied in relation to the Dockerfile ( in this case the same Directory ) and the following `\` is where they should be copied to in the Dockerfile.

### Adding packages

Notice how you cannot run the `xxx` script in this container? - this is because we are missing xxx on our dockerfile! ( Remeber Dockerfile should be built with the minimum packages needed) 

So lets try adding Bash to our dockerfile 

`RUN apk add bash` 

`RUN` will execute any commands in a new layer on top of the current image and commit the results into your Dockerfile. 

### Users

`USER 0`

### Entrypoints

`ENTRYPOINT ["python" "hello_script.py"]`
