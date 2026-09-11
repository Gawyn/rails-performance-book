# README

# Important Notes to run in the container

Update the memory to have 12 Gigs
Update the cpu to be 4
Make sure to not have anything else running on the same ports.
To start everything up simply run

```shell
docker-compose up
```

# Important Notes about changes

The seeds.rb has been updated to make inserting of the stores significantly faster.


By default, the datadog configuration won't work and needs to be updated with an API key.

To log into the rails_web container in order to have access to the ruby repl

```shell
docker exec -it rails_web /bin/bash
```

This README would normally document whatever steps are necessary to get the application up and running.

Things you may want to cover:

Ruby version

System dependencies

Configuration

Database creation

Database initialization

How to run the test suite

Services (job queues, cache servers, search engines, etc.)

Deployment instructions