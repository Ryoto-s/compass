# compass <!-- omit in toc -->

A flashcard app for learning by rails API mode.

# Table of Contents <!-- omit in toc -->
- [1. The App Explanation](#1-the-app-explanation)
- [2. Usage](#2-usage)
- [3. How to build(First set up)](#3-how-to-buildfirst-set-up)
  - [3.1. build this app on docker](#31-build-this-app-on-docker)
  - [3.2. Setup user](#32-setup-user)
  - [3.3. Login and issue token](#33-login-and-issue-token)
- [4. Everything is Ready!](#4-everything-is-ready)
  - [4.1. Let's create first card.](#41-lets-create-first-card)
  - [4.2. Other operations for flashcard](#42-other-operations-for-flashcard)
  - [4.3. Operate images](#43-operate-images)
  - [4.4. Answer to flashcard](#44-answer-to-flashcard)

# 1. The App Explanation

This is the flashcard app that contains data and functions of it.

# 2. Usage

We will add usage of this app later until the app developed enough.

# 3. How to build(First set up)

## 3.1. build this app on docker

- Setup database information.

  - You can do this by creating a `config/database.yml` file.
  - Sample configurations can be found in `config/database.sample.yml`. Copy these to `config/database.yml`.

- Setup secrets.

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

## 3.2. Setup user

- To sign up user, command as follows:

  ```
  curl -X POST -H "Content-Type: application/json"\
    -d '{"user":{"email":"test.user@example.com","password":"password"} }'\
    localhost:3000/signup
  ```

- Then, the message 'Signed in successfully.' will be shown.

## 3.3. Login and issue token

- by command:

  ```
  curl -X POST -H "Content-Type: application/json"\
    -d '{"user":{"email":"test.user@example.com","password":"password"} }'\
    -v localhost:3000/login
  ```

- Then, the message 'Logged in successfully.' will be shown. And the Bearer token will be attached in the header.
- Must use this issued token for other operations.

# 4. Everything is Ready!
## 4.1. Let's create first card.

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

> [!NOTE]
> You can choose shared_flag from
> - 'public_card', 'friends_only', and 'private_card'

## 4.2. Other operations for flashcard

### Find out flashcard

- by command

```
curl -X GET -H "Content-Type: application/json"\
 -H "Authorization: Bearer ----Input issued token----"\
 localhost:3000/api/v1/flashcards/1
```

- And then, data of flashcard will be shown in response

### Update flashcard

- Update with putting returned data from found:

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

## 4.3. Operate images

- Image can be added using a separate command from the flashcard creation command, as follows:

```
curl -X POST \
 -H "Authorization: Bearer ----Input issued token----"\
 -F "flashcard_image[image]=@path/to/image"
 localhost:3000/api/v1/images/3/create
```

> [!Important]
> Number in the URI must therefore be ID of the flashcard_master.
> And file format accepts only jpg, jpeg, png, webp, gif, and svg.

- And to update image, just type like below:

```
curl -X PATCH \
 -H "Authorization: Bearer ----Input issued token----"\
 -F "flashcard_image[image]=@path/to/image"
 localhost:3000/api/v1/images/3
```

- Also image can be deleted by command as follows:

```
curl -X DELETE \
 -H "Authorization: Bearer ----Input issued token----"\
 localhost:3000/api/v1/images/3
```

## 4.4. Answer to flashcard

- There are two ways to answering flashcard depend on input_enabled value
  - true: Compare input value and answer value
  - false: Choose from 'correct', 'intermediate', 'incorrect', and 'not_sure' to mark answer status

1. input enabled ver. command:

```
curl -X POST -H "Content-Type: application/json"\
 -H "Authorization: Bearer ----Input issued token----"\
 -d '{"answer": "input value of answer" }'\
 localhost:3000/api/v1/results/1/create
```

> [!Tip]
> Case and space be ignored in comparing answers

2. Input disabled ver. command:

```
curl -X POST -H "Content-Type: application/json"\
 -H "Authorization: Bearer ----Input issued token----"\
 -d '{"results": {"result": "correct" } }'\
 localhost:3000/api/v1/results/1/answer
```

> [!Important]
> Number in the URI must therefore be ID of the flashcard_master.

### Confirm latest answer status by:

```
curl -X GET -H "Content-Type: application/json"\
 -H "Authorization: Bearer ----Input issued token----"\
 localhost:3000/api/v1/results/1/latest_result
```
