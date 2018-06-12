defmodule Mix.Tasks.Lfe.Deps.Setup do
  use Mix.Task

  @shortdoc "Gets and compiles LFE and other initial dependencies"

  @moduledoc """
  A task for downloading and compiling the dependencies needed by a LFE project.

  This includes downloading the dependenices from https://hex.pm and
  installing rebar3.
  Rebar3 is needed to compile the LFE compiler itself, but this can't happen automatically,
  so it is done manually.

  Should be ran only once, when the project is created.

  Running `mix lfe.new <project> --setup` will do that, so tunning this one won't be needed.
  """

  @doc """
  Runs this task.
  """
  def run(_), do: Mix.Deps.Lfe.setup()
end

