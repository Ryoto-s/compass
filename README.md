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
- And add `BASE_URL`, `RAILS_MASTER_KEY` and `SECRET_KEY_BASE` to .env

  - `BASE_URL` is localhost:3000
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

- To sign up user, command as follows:

  ```bash
  curl -X POST -H "Content-Type: application/json"\
    -d '{"user":{"email":"test.user@example.com","password":"password"}}'\
    localhost:3000/signup
  ```

- Then, the message 'Signed in successfully.' will be shown.

## Login

- by command:

  ```
  curl -X POST -H "Content-Type: application/json"\
    -d '{"user":{"email":"test.user@example.com","password":"password"} }'\
    -v localhost:3000/login
  ```

- Then, the message 'Logged in successfully.' will be shown. And the Bearer token will be attached in the header.

## Getting Ready! Let's create first card.

- Create one by command:

```
curl -X POST -H "Content-Type: application/json"\
 -d\
 '{"flashcard_master":{
    "use_image": true,"input_enabled":false,"shared_flag": "friends_only",
    "flashcard_definition_attributes":{
    "word": "Ruby on Rails","answer": "A cool programming language for cool guys","language": "en"
    }
  } }'\
 -H "Authorization: Bearer ----Input issued token----"\
 localhost:3000/api/v1/flashcards
```

## Other operations for flashcard

### Find out flashcard

- by command

```
curl -X GET -H "Content-Type: application/json"\
 -H "Authorization: Bearer ----Input issued token----"\
 localhost:3000/api/v1/flashcards/1
```

- And then, data of flashcard will be shown in response

### Update flashcard

- At first, get flashcard data for edit

```
curl -X GET -H "Content-Type: application/json"\
 -H "Authorization: Bearer ----Input issued token----"\
 localhost:3000/api/v1/flashcards/1/edit
```

- And command for update with putting returned data:

```
curl -X PATCH -H "Content-Type: application/json"\
 -H "Authorization: Bearer ----Input issued token----"\
 localhost:3000/api/v1/flashcards/1\
 -d\
 '{"flashcard_master": {"id": 1,"user_id": 1,"use_image": false,"shared_flag": "private_card",
    "flashcard_definition_attributes": {"id": 1,"word": "Changing flashcard","answer": "Updated Content","language": "ja"
    } } }'
```

> [!IMPORTANT]
> Don't forget to add `_attributes` after `flashcard_definition`

### Delete flashcard(logical deletion)

- To delete, just command:

```
curl -X DELETE -H "Content-Type: application/json"\
 -H "Authorization: Bearer ----Input issued token----"\
 localhost:3000/api/v1/flashcards/1
```

### Search for flashcards by keywords

- Only flashcards created by you will be shown by:

```
curl -X GET -H "Content-Type: application/json"\
 -H "Authorization: Bearer ----Input issued token----"\
 localhost:3000/api/v1/flashcards/search?q=a+b
```

> [!NOTE]
> Multiple search keywords can be specified, separated by '+'.
> And search keywords is applied to words, answers, and languages

- or including flashcard created and publicly shared by other users by:

```
curl -X GET -H "Content-Type: application/json"\
 -H "Authorization: Bearer ----Input issued token----"\
 localhost:3000/api/v1/flashcards/global_search?q=a+b
```

### Add image

- Image can be added using a separate command from the flashcard creation command, as follows:

```
curl -X POST \
 -H "Authorization: Bearer ----Input issued token----"\
 -F "flashcard_image[image]=@path/to/image"
 localhost:3000/api/v1/images/3/create
```

# Other information

- Recommended Extensions on VSCode
  - Ruby Solargraph
  - ruby-rubocop
  - Postman
