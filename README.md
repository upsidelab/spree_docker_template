# Spree Docker Template

This repository contains a basic Dockerfile and Docker Compose templates for running Spree-based applications.

The Dockerfile is based on latest Ruby image, it also installs required dependencies for the application (Yarn, PostgreSQL libraries, ImageMagick).

Included Docker Compose creates a two containers that can be used in development or test deployments: one for Spree and one for PostgreSQL.

## Setup

**1. Move the contents of this repository to the root of your project**

**2. Configure database access**

By default, the hostname of the database is `postgres` and the port is `5432`. To make your Rails application connect with it you can either:
- set the database host, password etc. directly in your projects `database.yml`
- add environment variables used in `database.yml` to the web service in `docker-compose.yml`, e.g.
```yaml
spree:
  environment:
    DB_USER: spree_postgres
    DB_PASSWORD: password
    DB_HOST: postgres
    DB_PORT: 5432
``` 

**3. Build the images:**
```console
$ docker-compose build
```
The version of the bundler included in the alpine image (1.17.2) may be different than the bundler used in your project. You can find the right version in the `BUNDLED_WITH` section of your `Gemfile.lock`.

You can make it use your version by passing it as a build argument when running `docker-compose build`:
```console
$ docker-compose build --build-arg BUNDLER_VERSION=<YOUR_BUNDLER_VERSION>
```
or place it directly in the `environment` of the `spree` service in `docker-compose.yml`:
```yaml
spree:
  build:
    context: .
    args:
      BUNDLER_VERSION: 2.1.2
```
Since the default compose uses the `build: context` syntax you need to explicitly add the `context` path.

The image also uses Ruby 2.6.6 by default. If you need another version for your project you can set it identically to how you set BUNDLER_VERSION:

```console
$ docker-compose build --build-arg RUBY_VERSION=<YOUR_RUBY_VERSION>
```

or change `docker-compose.yml`:
```yaml
spree:
  build:
    context: .
    args:
      RUBY_VERSION: 2.7.0
```

**4. Create the databases**
```console
$ docker-compose run spree rails db:create
```

**5. Load the schema**
```console
$ docker-compose run spree rails db:schema:load
```

**6. Seed the database**
```console
$ docker-compose run spree rails db:seed
```

**7. Precompiling assets**
If you wish to precompile assets you can do so by running:
```console
$ docker-compose run spree rails assets:precompile
```

## Running the application

To run the application simply execute:
```console
$ docker-compose up
```

You should now be able to visit http://localhost:3000 in your browser.
