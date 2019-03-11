defmodule Code2pdfWeb.PageController do
  use Code2pdfWeb, :controller

  alias Code2pdf.Convert

  def index(conn, _params) do
    render conn, "index.html"
  end

  def convert(conn, %{"github_url" => url}) do
  	IO.inspect(url)
  	:ok = Convert.process(url)
    render conn, "index.html"
  end
end
