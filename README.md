# Bookshare

## Table of content:
* [Project description](#project-description)
* [Technologies](#technologies)
* [Setup](#setup)
* [Features](#features)
* [Contribution](#contribution)


## Project description
Backend api made as a foundation to project for people who love books. Application let people borrow or buy/sell books to each other. 

## Technologies

- Elixir 1.12
- Phoenix 1.6.13
- Ecto 3.6
- PostgreSQL

## Setup

#### Clone to repository
```
$ git clone https://github.com/mateuszbabski/Bookshare
```

#### Go to the folder you cloned
```
$ cd Bookshare
```

#### Instal dependencies
```
mix deps.get
```

#### Create and migrate database
```
mix ecto.setup
```

#### Start Phoenix server
```
mix phx.server
```

#### Visit [`localhost:4000`](http://localhost:4000)

## Features

- Full custom authentication proccess for a user including reset/forgot password
- Confirmation emails
- Adding, updating and deleting books available to borrow/sell
- Leaving review to a user and possibility to respond to it
- Full Unit tests

To implement:
- Chat/Message features
- Live notifications

## Contribution

Feel free to fork project and work on it with me. I am open to any suggestions how to make it better.
