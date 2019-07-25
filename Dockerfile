FROM alpine:3.9

RUN apk add --no-cache \
  bats \
  git \
  bash \
  gawk

WORKDIR /argsh
COPY . .
RUN ln -s $(pwd)/bin/argsh /bin/

ENTRYPOINT ["bats", "tests/argsh.bats"]