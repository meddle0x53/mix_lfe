defmodule MixLfe.MixProject do
  use Mix.Project

  @version "0.2.0-rc1"

  def project do
    [
      app: :mix_lfe,
      version: @version,
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      description: "A LFE compiler for Mix",
      docs: [
        extras: ["README.md"],
        main: "readme",
        source_ref: "v#{@version}",
        source_url: "https://github.com/meddle0x53/mix_lfe"
      ],
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
      {:lfe, "~> 1.2"},
      {:ltest, "0.10.0-rc6"},
      {:color, "~> 1.0", hex: :erlang_color},
      {:lutil, "~> 0.10.0-rc6"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
