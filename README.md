# A simple Docker guide

This repo is designed for a friendly step by step introduction to building your first Docker container.

This starts with the image `python:alpine3.13`

- [Building a dockerfile](#building-a-dockerfile)
- [Running your container](#running-your-container)
- [Adding files](#adding-files)
- [Addding packages](#adding-packages)
- [Users](#users)
- [Entrypoints](#entrypoints)


### Building a dockerfile

To build your dockerfile run the command 
```console
docker build -t <yourdockername>/<my_dockefile>:1 .
```

### Running your container 

To create a container based off your newly built docker image run:
```console
docker run -it <yourdockername>/<my_dockefile>:1 sh
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
