FROM alpine:latest
RUN apk update && apk add bash
# install Ruby3
RUN apk add --no-cache ruby-dev
# install Python
RUN apk add --no-cache python2
# install Python3
RUN apk add --no-cache python3
# install Golang
RUN apk add --no-cache go
# install C++
RUN apk add --no-cache g++
# install Java
RUN apk add --no-cache openjdk11
# install Kotlin
RUN apk add --no-cache -t build-dependencies wget && \
    cd /usr/lib && \
    wget https://github.com/JetBrains/kotlin/releases/download/v1.6.10/kotlin-compiler-1.6.10.zip && \
    unzip kotlin-compiler-*.zip && \
    rm kotlin-compiler-*.zip && \
    rm kotlinc/bin/*.bat && \
    apk del --no-cache build-dependencies
ENV PATH $PATH:/usr/lib/kotlinc/bin
# install Javascript
RUN apk add --no-cache nodejs

ENV APP_ENV="development"

WORKDIR /app/runtime
ADD . /app/runtime

# add less priviledged user
RUN addgroup -S hackerpen && adduser -S hackerpen -G hackerpen -s /bin/bash
RUN mkdir /hackerpen
RUN chown hackerpen:hackerpen -R /hackerpen
RUN chown hackerpen:hackerpen -R /app/runtime

RUN gem install bundler
RUN bundle install
CMD bash -c "bin/server"
