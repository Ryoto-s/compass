# compass

A word book app for learning by rails API mode.

# The App Explanation

This is the word book app that contains data and functions of it.

# Usage

We will add usage of this app later until the app developed enough.

# How to build(First set up)

## build this app on docker

- create `.env` file and copy values from `.env.sample` to `.env`
- Commands for build the app.
```
$ docker compose build

$ docker compose exec web rails db:create

$ docker compose exec web rails db:migrate

$ docker compose up -d
```

- check if build success
  `GET: localhost:3000/api/v1/health` and you'll see HTTP status.

## Setup user

- To sign up user, API request as follows

  `POST localhost:3000/signup`

  Body(json): `{"email":"test.user@example.com","password":"password"}}`

  HEADER: `Content-Type` `application/json`

- or command

  ```
  curl -X POST -H "Content-Type: application/json"\
    -d '{"user":{"email":"test.user@example.com","password":"password"}}'\
    localhost:3000/signup
  ```

- Then, the message 'Signed in successfully.' will be shown.

## Login

- API request as follows

  `POST localhost:3000/login`

  Body(json): `{"user": {"email":"test.user@example.com","password":"password"}}`

  HEADER: `Content-Type` `application/json`

- or command

  ```
  curl -X POST -H "Content-Type: application/json"\
    -d '{"user":{"email":"test.user@example.com","password":"password"}}'\
    -v localhost:3000/login
  ```

- Then, the message 'Logged in successfully.' will be shown. And the Bearer token will be attached in the header.

# Other information

- Recommended Extensions on VSCode
  - Ruby Solargraph
  - ruby-rubocop
  - Postman
