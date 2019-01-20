defmodule Code2pdf.File do
  @reject [~r{\/\.}, ~r{.png}, ~r{_build}, ~r{test}, ~r{deps}, ~r{assets}, ~r{.eex}, ~r{priv}]

  def generate(file) do
    {:ok, result_file} = File.open(file <> ".txt", [:append])
    :ok = generate_txt([file], result_file)
    File.close(result_file)
    generate_pdf(file)
  end

  defp generate_pdf(file) do
    if cmd_path = System.find_executable("wkhtmltopdf") do
      System.cmd(cmd_path, ["--encoding", "utf-8", file <> ".txt", file <> ".pdf"])
      :ok
    else
      nil
    end
  end

  defp generate_txt(folder, result_file) when is_list(folder) do
    :ok = Enum.each(folder, fn file -> 
      generate_txt(get_all(file), result_file) 
    end)
  end

  defp generate_txt(file, result_file) do
    case file_type(file) do
      "text" ->
        {:ok, to_write} = File.read(file)
        IO.puts(result_file, <<"\n----------------------------------------------------------">>)
        IO.binwrite(result_file, file)
        IO.puts(result_file, <<"\n----------------------------------------------------------">>)
        IO.binwrite(result_file, to_write)
      _ ->
        :nothing
    end
  end

  defp get_all(folder) do
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

  defp file_type(file) do
    {file_mime, _} = System.cmd("file", ["--mime", file])
    
    file_mime
    |> String.split(":")
    |> tl
    |> to_string
    |> String.split("/")
    |> hd
    |> String.trim

  end
end