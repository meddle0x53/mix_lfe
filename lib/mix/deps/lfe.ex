defmodule Mix.Deps.Lfe do
  @moduledoc """
  Deals with getting and compiling the LFE related dependencies.
  """

  @doc """
  Downloads and compiles the dependencies needed by a LFE project.

  This includes downloading the dependenices from https://hex.pm and
  installing rebar3.
  Rebar3 is needed to compile the LFE compiler itself, but this can't happen automatically,
  so it is done manually.
  """
  def setup do
    Mix.Shell.cmd("mix deps.get", fn(output) -> IO.write(output) end)
    Mix.Shell.cmd("mix local.rebar --force", fn(output) -> IO.write(output) end)

    local_rebar = Mix.Rebar.local_rebar_path(:rebar3)
    File.cd!(Path.join("deps", "lfe"), fn ->
      Mix.Shell.cmd("#{local_rebar} compile", fn(output) -> IO.write(output) end)
    end)
  end
end
