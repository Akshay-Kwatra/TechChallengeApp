FROM golang:alpine AS build

RUN apk add --no-cache curl git alpine-sdk

RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

ARG SWAGGER_UI_VERSION=3.20.9

RUN go get -d -v github.com/go-openapi/analysis \
    && go get -d -v github.com/go-openapi/errors \
    && go get -d -v github.com/go-openapi/inflect \
    && go get -d -v github.com/go-openapi/loads \
    && go get -d -v github.com/go-openapi/runtime \
    && go get -d -v github.com/go-openapi/validate \
    && go get -d -v github.com/jessevdk/go-flags \
    && go get -d -v github.com/go-swagger/go-swagger \
    && go get -d -v github.com/gorilla/handlers \
    && go get -d -v github.com/kr/pretty \
    && go get -d -v github.com/spf13/viper \
    && go get -d -v github.com/pkg/errors \
    && go get -d -v golang.org/x/tools/go/packages \
    && go get -d -v github.com/toqueteos/webbrowser \
    && go install github.com/go-swagger/go-swagger/cmd/swagger \
    && curl -sfL https://github.com/swagger-api/swagger-ui/archive/v$SWAGGER_UI_VERSION.tar.gz | tar xz -C /tmp/ \
    && mv /tmp/swagger-ui-$SWAGGER_UI_VERSION /tmp/swagger \
    && sed -i 's#"https://petstore\.swagger\.io/v2/swagger\.json"#"./swagger.json"#g' /tmp/swagger/dist/index.html

WORKDIR $GOPATH/src/github.com/servian/TechTestApp

COPY Gopkg.toml Gopkg.lock $GOPATH/src/github.com/servian/TechTestApp/

RUN dep ensure -vendor-only -v

COPY . .

RUN go build -o /TechTestApp
RUN swagger generate spec -o /swagger.json

FROM alpine:latest

WORKDIR /TechTestApp

COPY assets ./assets
COPY conf.toml ./conf.toml

COPY --from=build /tmp/swagger/dist ./assets/swagger
COPY --from=build /swagger.json ./assets/swagger/swagger.json
COPY --from=build /TechTestApp TechTestApp

ENTRYPOINT [ "./TechTestApp", "serve" ]
