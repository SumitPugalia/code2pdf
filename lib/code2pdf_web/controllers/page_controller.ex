defmodule Code2pdfWeb.PageController do
  use Code2pdfWeb, :controller
  @reject [~r{\/\.}, ~r{.png}]
  def index(conn, _params) do
    render conn, "index.html"
  end

  def browse(conn, %{"github_url" => url}) do
  	IO.puts "++++++++++++++++++++++++++++"
  	IO.inspect url
  	IO.puts "++++++++++++++++++++++++++++"
  	folder = solve(url)
  	:ok = solve2(folder)
    redirect conn, to: page_path(conn, :index)
  end

  def solve(url) do
  	folder = url
  		|> String.split("/")
  		|> List.last
  		|> String.split(".git")
  		|> List.first()

  	args = ["--git-dir=.git", "clone", url]
  	:ok = git!(args)
  	folder
  end

  def solve2(folder) do
  	{:ok, result_file} = File.open(folder <> ".txt", [:append])
  	:ok = generate_pdf([folder], result_file)
  	File.close(result_file)
  end

  defp git!(args, into \\ "") do
	  case System.cmd("git", args, into: into, stderr_to_stdout: true) do
	    {_response, 0} -> :ok
	    {_, _} -> :ok #Mix.raise("Command \"git #{Enum.join(args, " ")}\" failed")
	  end
	end

	def generate_pdf(folder, result_file) when is_list(folder) do
		:ok = Enum.each(folder, fn file -> generate_pdf(get_all(file), result_file) end)
	end

	def generate_pdf(file, result_file) do
		{:ok, to_write} = File.read(file)
	  IO.puts(result_file, <<"----------------------------------------------------------">>)
	  IO.binwrite(result_file, file)
	  IO.puts(result_file, <<"\n----------------------------------------------------------">>)
		IO.binwrite(result_file, to_write)
	end

	def get_all(folder) do
		case File.dir? folder do
			true ->
				# if not String.match?(folder, ~r{/.}) do
				{:ok, files} = File.ls(folder)
				files
				|> Enum.map(fn file -> folder <> "/" <> file end)
				|> Enum.reject(fn file -> 
					Enum.any?(@reject, fn regx -> String.match?(file, regx) end) 
				end)
				# end
			false ->
				folder
		end
	end

end

