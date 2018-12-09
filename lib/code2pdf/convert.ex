defmodule Code2pdf.Convert do  
  @reject [~r{\/\.}, ~r{.png}, ~r{_build}, ~r{test}, ~r{deps}, ~r{assets}, ~r{.eex}, ~r{priv}]
  
  def process(url) do
    folder = clone(url)
    :ok = generate(folder)
  end

  def clone(url) do
    folder = url
      |> String.split("/")
      |> List.last
      |> String.split(".git")
      |> List.first()

    args = ["--git-dir=.git", "clone", url]
    :ok = git!(args)
    folder
  end

  def generate(folder) do
    {:ok, result_file} = File.open(folder <> ".txt", [:append])
    :ok = generate_txt([folder], result_file)
    File.close(result_file)
    generate_pdf(folder)
  end

  defp git!(args, into \\ "") do
    case System.cmd("git", args, into: into, stderr_to_stdout: true) do
      {_response, 0} -> :ok
      {_, _} -> Mix.raise("Command \"git #{Enum.join(args, " ")}\" failed")
    end
  end

  def generate_pdf(file) do
    if cmd_path = System.find_executable("wkhtmltopdf") do
      System.cmd(cmd_path, ["--encoding", "utf-8", file <> ".txt", file <> ".pdf"])
      :ok
    else
      nil
    end
  end

  def generate_txt(folder, result_file) when is_list(folder) do
    :ok = Enum.each(folder, fn file -> generate_txt(get_all(file), result_file) end)
  end

  def generate_txt(file, result_file) do
    {:ok, to_write} = File.read(file)
    IO.puts(result_file, <<"\n----------------------------------------------------------">>)
    IO.binwrite(result_file, file)
    IO.puts(result_file, <<"\n----------------------------------------------------------">>)
    IO.binwrite(result_file, to_write)
  end

  def get_all(folder) do
    case File.dir? folder do
      true ->
        {:ok, files} = File.ls(folder)
        files
        |> Enum.map(fn file -> folder <> "/" <> file end)
        |> Enum.reject(fn file -> 
          Enum.any?(@reject, fn regx -> String.match?(file, regx) end) 
        end)
      false ->
        folder
    end
  end
end
