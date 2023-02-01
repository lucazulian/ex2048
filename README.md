# Ex2048

A multiplayer version of 2048 game with Phoenix Liveview

[![CI](https://github.com/lucazulian/ex2048/actions/workflows/ci.yml/badge.svg)](https://github.com/lucazulian/ex2048/actions/workflows/ci.yml)


## About the Application

`ex2048` is a Phoenix application with a LiveView front-end. 2048 is a single-player puzzle game where the objective is to slide numbered tiles on a grid to combine them and create a tile with the number 2048. The game starts with a 4x4 grid with two tiles of value 2 or 4. The player moves the tiles by sliding them in any of the four directions (up, down, left, right) until two tiles of the same value touch, then they merge into a tile with the value equal to the sum of the original two tiles. The game ends when there are no more moves possible and the player's goal is to create the highest tile possible before the game ends.

Specifications
- The grid consists of 6x6 tiles
- At the beginning of a game the grid is empty, except for one tile of value 2 placed at random
- The user can slide the tiles either up, down, left or right
- After each slide a new tile with value 1 will appear in a random free space. If there is no free space to put the new tile the game is lost
- During the slide, tiles of equal values pushed into each other will merge into a new tile with the combined value. 2 + 2 = 4
- If there are 3 values next to each other, e.g. 2 2 2, and the player slides right, the values closest to the wall should merge first resulting in 2 4
- If any tile reaches the value 2048 the game is won.

## How it works

You can play `ex2048` stating from [`localhost:4000`](http://localhost:4000) from your browser. It should redirect to a new URL, like http://localhost:4000/game/fcvtqzkjbgdsnlxphuio. This is the link to a new game; you can share and play with others just by sharing it. The grid would be built with the default size and obstacles in this case.
You can start a new game by changing the size and obstacles with the `New Game` button.


## Requirements

Build and run project on your bare machine:

  - Erlang/OTP **25+**
  - elixir **1.14+**
  
or using docker-compose:

  - docker **20+**
  - docker-compose **1.29+**
  - GNU make **4+**
  

## Development links

  * [Elixir Style Guide](https://github.com/christopheradams/elixir_style_guide)
  

## Getting started
 
### Local environment

In your local environment it needs to install all **Requirements** beforehand.

#### Setup the application

```bash
mix setup
```

#### Start the application

```bash
mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


### Docker Compose

Docker Compose is used to simplify development and configuration.
Makefile is used as a wrapper around docker-compose commands.
Some commands are aliases around mix aliases, just to avoid boring and repetitive commands. 

#### Make commands

```bash
build                          Build all containers
delete                         Delete all containers, images and volumes
halt                           Shoutdown all containers
setup                          Setup application
shell                          Enter into game container
start                          Start application
up                             Start all containers
```

#### Setup application

```bash
make setup
```

#### Start application

```bash
make start
```

#### Destroy environment

```bash
make delete
```


## Assumptions

  - I would not take action if the game is won or not. In the former case, the user is allowed to continue playing the event after the 2048 score
  - I don't delete the played (or abandoned) matches
  - I don't save every game step (but if we want a feature like time travelling we should store it in some way)
  

## Improvements / Missing parts

  - a11y - I did not spend time on it, but I think it would be important
  - css - fix some strange behaviour
  - mobile - the UI is not tested on mobile devices
  - performance - for big grid I think it would be useful to replace `Enum` with `Stream`
  - testing - I did not spend time on UI and end to end test but just on algorithm and overall testing
  - user - there is not user / game persistence
  - checks - I did not spent time on some checks (like the maximum number of obstacles given a specific size etc.)
