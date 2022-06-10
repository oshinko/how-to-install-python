FROM amazonlinux:2
ARG VERSION
WORKDIR /app
COPY . .
RUN sh ./install-python.sh ${VERSION:-3.10.0}
