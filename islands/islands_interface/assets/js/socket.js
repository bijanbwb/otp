import { Socket } from "phoenix"

// Socket
let socket = new Socket("/socket", { params: { token: window.userToken } })

// Connection
socket.connect()

// Channel
let newChannel = (player, screen_name) =>
  socket.channel("game:" + player, { screen_name: screen_name })

// TODO
// Hard-coded name means this only works once.
let gameChannel = newChannel("bijanbwb", "Bijan")
let player2 = "Riley"

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
addPlayer(gameChannel, player2)

// Listen for Added Players
gameChannel.on("player_added", response => {
  console.log("Player Added", response)
})

export default socket
