defmodule Mix.Tasks.Test.Lfe do
  use Mix.Task.Compiler
  import Mix.Compilers.Lfe

  @recursive true
  @manifest "test.lfe"
  @switches [force: :boolean, all_warnings: :boolean]

  @moduledoc """
  Compiles the source LFE source files of the project, using `Mix.Compilers.Lfe`
  and also compiles and runs all the test LFE files with the '-tests.lfe' extension in the
  'test' folder of the project.

  Uses the [ltest](https://github.com/lfex/ltest) library to do so.

  For the compilation it supports the command line options and the configuration of the `Mix.Tasks.Compile.Lfe` task.
  """

  @doc """
  Runs this task.
  """
  def run(args) do
    {opts, _, _} = OptionParser.parse(args, switches: @switches)
    Mix.env(:test)

    do_run(opts)
  end

  @doc """
  Returns LFE test manifests.
  """
  def manifests, do: [manifest()]

  defp do_run(opts) do
    dest = Mix.Project.compile_path() |> String.replace("_build/dev", "_build/test")
    location = String.split(dest, "_build") |> List.last()
    {:ok, root} = File.cwd()
    dest = root |> Path.join("_build") |> Path.join(location)

    File.rmdir(dest)
    File.mkdir_p!(dest)

    dest_test = dest |> Path.join("_build") |> Path.join(location)

    File.rmdir(dest_test)
    File.mkdir_p!(dest_test)

    compile(manifest(), [{"src", dest}, {"test", dest_test}], opts)

    File.cd(dest)

    :"ltest-runner".unit()
  end

  defp manifest, do: Path.join(Mix.Project.manifest_path(), @manifest)
end
