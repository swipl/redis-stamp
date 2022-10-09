FROM ghcr.io/proganon/redis-srvpl:v0.1.0
COPY *.pl ./
RUN find . -name \*.pl -exec chmod -x \{\} \;
