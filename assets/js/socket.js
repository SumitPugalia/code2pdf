import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()
document.getElementById('download').style.visibility = 'hidden';
// Now that you are connected, you can join channels with a topic:

document.getElementById('convert').addEventListener('click', function() {

	var url = document.getElementById('github_url').value
	var value = url.split("/")
	value = value[value.length - 1]

	let channel = socket.channel("file:" + value, {})
	
	channel.join()
  	.receive("ok", resp => { console.log("Joined successfully", resp) })
  	.receive("error", resp => { console.log("Unable to join", resp) })

	channel.push('file', {subtopic: value, url: url})
	channel.on("file:" + value + ":converted", converted);

});

function converted(){
	document.getElementById('github_url').value = ""
	document.getElementById('download').style.visibility = 'visible';
};

export default socket
