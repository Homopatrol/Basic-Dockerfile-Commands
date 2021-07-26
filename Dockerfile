# Start here:
FROM python:3.9.5-alpine3.13

# Need to copy files from this repo into dockerfile?

#COPY / /files

#ARG UID=47
#ARG GID=47

# Do we need to perform any additional commands?

#RUN chown -R ${UID}:0 /files && \
#     chmod -R g=u /files
# apk add git
# git clone .... 

#USER ${UID}

#WORKDIR files/

#ENTRYPOINT ["python", "hello_python.py"]
