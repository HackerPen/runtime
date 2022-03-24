# Runtime

Open sourced runtime environment. Support the following languages:

- Ruby
- Python
- Javascript
- Go
- C
- C++

## Dependency

- Docker Desktop

## Develop

- clone the repo
- ensure Docker Desktop is running
- `docker-compose up -d`
- hit `localhost:9494` in a browser and you should see `{"status": "ok"}`

## Test

- clone the repo
- ensure Docker Desktop is running
- `docker-compose up -d`
- `docker-compose exec runtime bash`
- `rspec spec`
- make sure all tests pass


## Deploy

TBD
