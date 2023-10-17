# compass

A word book app for learning by rails API mode.

# The App Explanation

This is the word book app that contains data and functions of it.

# Usage

We will add usage of this app later until the app developed enough.

# How to build(First set up)

- clone repository

  `$ cd your_workspace/`

  `$ git clone https://github.com/Ryoto-s/compass.git`
  
  `$ cd compass/`


- build this app on docker

  set RAILS_MASTER_KEY to entrypoint.sh

  `$ docker compose build`

  `$ docker compose exec web rails db:create`

  `$ docker compose exec web rails db:migrate`
  
  `$ docker compose up -d`


- check if build success
  Go to `localhost:3000` and you'll see Rails start page

# Other information

- Recommended Extensions on VSCode
  - Ruby Solargraph
  - ruby-rubocop
  - Postman
