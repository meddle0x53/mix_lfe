defmodule MixLfe.MixProject do
  use Mix.Project

  def project do
    [
      app: :mix_lfe,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      description: "A LFE compiler for Mix",
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  def package do
    %{
      licenses: ["Apache 2"],
      links: %{"GitHub" => "https://github.com/meddle0x53/mix_lfe"},
      maintainers: ["Nikolay Tsvetinov (Meddle)"]
    }
  end

  def deps do
    [
      {:lfe, "~> 1.2", override: true, manager: :rebar}
    ]
  end
end
