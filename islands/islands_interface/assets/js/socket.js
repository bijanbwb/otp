import { Socket } from "phoenix"

// Socket
let socket = new Socket("/socket", { params: { token: window.userToken } })

// Connection
socket.connect()

// Channel
let newChannel = (player, screen_name) =>
  socket.channel("game:" + player, { screen_name: screen_name })

let gameChannel = newChannel("game", "player1")

// Join
function join(channel) {
  channel.join()
    .receive("ok", response => { console.log("Joined successfully!", response) })
    .receive("error", response => { console.log("Unable to join.", response) })
}

join(gameChannel)

// Leave
function leave(channel) {
  channel.leave()
    .receive("ok", response => { console.log("Left successfully", response) })
    .receive("error", response => { console.log("Unable to leave. You're here forever.", response) })
}

// New Game
function newGame(channel) {
  channel.push("new_game")
    .receive("ok", response => { console.log("New Game!", response) })
    .receive("error", response => { console.log("Unable to start a new game.", response) })
}

newGame(gameChannel)

// Add Player
function addPlayer(channel, player) {
  channel.push("add_player", player)
    .receive("error", response => { console.log("Unable to add new player: " + player, response) })
}
addPlayer(gameChannel, "player2")

// Listen for Added Players
gameChannel.on("player_added", response => {
  console.log("Player Added", response)
})

// Islands
function positionIsland(channel, player, island, row, col) {
  let params = {
    "player": player,
    "island": island,
    "row": row,
    "col": col
  }

  channel.push("position_island", params)
    .receive("ok", response => {
      console.log("Islands positioned!", response)
    })
    .receive("error", response => {
      console.log("Unable to position island.", response)
    })
}

// positionIsland(gameChannel, "player2", "atoll", 1, 1)
positionIsland(gameChannel, "player2", "dot", 1, 5)
positionIsland(gameChannel, "player2", "l_shape", 1, 7)
positionIsland(gameChannel, "player2", "s_shape", 5, 1)
positionIsland(gameChannel, "player2", "square", 5, 5)
positionIsland(gameChannel, "player1", "square", 1, 1)

function setIslands(channel, player) {
  channel.push("set_islands", player)
    .receive("ok", response => {
      console.log("Here is the board:")
      console.dir(response.board)
    })
    .receive("error", response => {
      console.log("Unable to set islands for: " + player, response)
    })
}

// setIslands(gameChannel, "player2")

gameChannel.on("player_set_islands", response => {
  console.log("Player Set Islands", response)
})

// Guesses
function guessCoordinate(channel, player, row, col) {
  let params = {
    "player": player,
    "row": row,
    "col": col
  }

  channel.push("guess_coordinate", params)
    .receive("error", response => {
      console.log("Unable to guess a coordinate: " + player, response)
    })
}

gameChannel.on("player_guessed_coordinate", response => {
  console.log("Player Guessed Coordinate", response.result)
})

// guessCoordinate(gameChannel, "player1", 10, 1)

// Presence

gameChannel.on("subscribers", response => {
  console.log("These players have joined: ", response)
})

gameChannel.push("show_subscribers")

export default socket
