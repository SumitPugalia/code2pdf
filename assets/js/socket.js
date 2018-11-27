import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("file:1", {})
// call join in channel..
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on('file:1:pressed', press);

document.querySelector('button').addEventListener('click', function() {
	channel.push('fil:file', {hi: 'tehre'})
});

function press(){
	console.log("pressed")
};

export default socket
