# Start here:
FROM python:3.9.5-alpine3.13

# Do we need to copy files from this repo into container?
#COPY / /files

# Additional arguments to be used when writing this Dockerfile.
#ARG UID=47

# Do we need to perform any additional commands?
#RUN  apk add git && \
#     git clone https://github.com/johnmosesman/practical-git-tutorial && \
#     chown -R ${UID}:0 /files && \
#     chmod -R g=u /files

# change to run container as USER 47
#USER ${UID}

# Do we want to start the container in a different directory?
#WORKDIR files/

# Perform this command when the container is ran ("python hello_python.py").
#ENTRYPOINT ["python", "hello_python.py"]
