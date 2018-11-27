defmodule Code2pdfWeb.FileChannel do
  use Code2pdfWeb, :channel

  def join("file:1", params, socket) do
  	IO.puts "join"
  	IO.inspect params
    {:ok, %{test: "Joined"}, socket}
  end

  def handle_in(name, params, socket) do
  	IO.puts "handle_in"
    IO.inspect params
    #socket, name_of_event
    # make sure to watch this event
    broadcast!(socket, "file:1:pressed", %{})
    {:reply, :ok, socket}
  end
end