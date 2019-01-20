defmodule Code2pdf.Convert do  
  @reject [~r{\/\.}, ~r{.png}, ~r{_build}, ~r{test}, ~r{deps}, ~r{assets}, ~r{.eex}, ~r{priv}]
  
  def process(url) do
    folder = clone(url)
    :ok = Code2pdf.File.generate(folder)
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

  defp git!(args, into \\ "") do
    case System.cmd("git", args, into: into, stderr_to_stdout: true) do
      {_response, 0} -> :ok
      {_, _} -> Mix.raise("Command \"git #{Enum.join(args, " ")}\" failed")
    end
  end
end
