# compass

A flashcard app for learning by rails API mode.

# The App Explanation

This is the flashcard app that contains data and functions of it.

# Usage

We will add usage of this app later until the app developed enough.

# How to build(First set up)

## build this app on docker

- Commands for setup secrets.

```
$ touch .env

$ EDITOR=vim bin/rails credentials:edit
```

- Then, save it and `master.key` will be created.
- And add `RAILS_MASTER_KEY` and `SECRET_KEY_BASE` to .env

  - `RAILS_MASTER_KEY` must be same as master.key
  - `SECRET_KEY_BASE` is optional. Just enter any value.

- You can build the app from now on.

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

  Body(json):
  ```
  {"email":
    "test.user@example.com","password":"password"
  }
  ```

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

  Body(json):
  ```
  {"user":
    {"email":"test.user@example.com","password":"password"}
  }
  ```

  HEADER: `Content-Type` `application/json`

- or command

  ```
  curl -X POST -H "Content-Type: application/json"\
    -d '{"user":{"email":"test.user@example.com","password":"password"}}'\
    -v localhost:3000/login
  ```

- Then, the message 'Logged in successfully.' will be shown. And the Bearer token will be attached in the header.

## Getting Ready! Let's create first card.

- Create one by API request:

  `POST localhost:3000/api/v1/flashcards`

  Body(json):
  ```
  {
    "flashcard_master": {
      "use_image": true,
      "status": true
      },
      "flashcard_definitions": {
        "word": "Ruby on Rails",
        "answer": "A cool programming language for cool guys",
        "language": "en" // optional
      }
  }
  ```

  HEADER: `Content-Type` `application/json`
  
  Authorization(Bearer): ----Input issued token----

- or command

```
curl -X POST -H "Content-Type: application/json"\
 -d\
 '{"flashcard_master":{
    "use_image": true,"status": true
  },"flashcard_definition":{
    "word": "Ruby on Rails","answer": "A cool programming language for cool guys","language": "en"}
  }'\
 -H 'Authorization: Bearer ----Input issued token----'\
 localhost:3000/api/v1/flashcards
```

# Other information

- Recommended Extensions on VSCode
  - Ruby Solargraph
  - ruby-rubocop
  - Postman
