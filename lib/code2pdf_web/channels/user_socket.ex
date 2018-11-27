  defmodule Code2pdfWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  # acts as router
  channel "file:*", Code2pdfWeb.FileChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
