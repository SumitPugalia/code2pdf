defmodule Code2pdfWeb.FileChannel do
  use Code2pdfWeb, :channel

  def join(topic, params, socket) do
    {:ok, %{}, socket}
  end

  def handle_in("file", %{"subtopic" => value, "url" => url}, socket) do
    #socket, name_of_event
    # make sure to watch this event
    Code2pdf.Convert.process url
    broadcast!(socket, "file:" <> value <> ":converted", %{})
    {:reply, :ok, socket}
  end

  def handle_in(topic, params, socket) do
    IO.puts "unwanted event"
  end
end