defmodule Mix.Tasks.Compile.LfeTest do
  use ExUnit.Case

  import Mix.Tasks.Compile.Lfe
  import ExUnit.CaptureIO

  @fixture_project Path.expand("../../fixtures/sample", __DIR__)

  defmodule Sample do
    def project do
      [app: :sample, version: "0.1.0", aliases: [sample: "compile"]]
    end
  end

  setup do
    Mix.start()
    Mix.shell(Mix.Shell.Process)
    Mix.Project.push(Sample)
    Mix.env(:dev)

    on_exit(fn ->
      Mix.env(:dev)
      Mix.Task.clear()
      Mix.Shell.Process.flush()
      Mix.ProjectStack.clear_cache()
      Mix.ProjectStack.clear_stack()

      delete_tmp_paths()
    end)

    :ok
  end

  test "compiles and cleans src/tut4.lfe and src/tut5.lfe" do
    in_fixture(fn ->
      assert run(["--verbose"]) == {:ok, []}
      assert_received {:mix_shell, :info, ["Compiled src/tut4.lfe"]}
      assert_received {:mix_shell, :info, ["Compiled src/tut5.lfe"]}

      assert File.regular?("_build/dev/lib/sample/ebin/tut4.beam")
      assert File.regular?("_build/dev/lib/sample/ebin/tut5.beam")

      assert run(["--verbose"]) == {:noop, []}
      refute_received {:mix_shell, :info, ["Compiled src/tut4.lfe"]}

      assert run(["--force", "--verbose"]) == {:ok, []}
      assert_received {:mix_shell, :info, ["Compiled src/tut4.lfe"]}
      assert_received {:mix_shell, :info, ["Compiled src/tut5.lfe"]}

      assert clean()
      refute File.regular?("_build/dev/lib/sample/ebin/tut4.beam")
      refute File.regular?("_build/dev/lib/sample/ebin/tut5.beam")
    end)
  end

  test "removes old artifact files" do
    in_fixture(fn ->
      assert run([]) == {:ok, []}
      assert File.regular?("_build/dev/lib/sample/ebin/tut4.beam")

      File.rm!("src/tut4.lfe")
      assert run([]) == {:ok, []}
      refute File.regular?("_build/dev/lib/sample/ebin/tut4.beam")
    end)
  end

  test "compilation purges the module" do
    in_fixture(fn ->
      # Create the first version of the module.
      defmodule :purge_test do
        def version, do: :v1
      end

      assert :v1 == :purge_test.version()

      # Create the second version of the module (this time as LFE source).
      File.write!("src/purge_test.lfe", """
      (defmodule purge_test
        (export (version 0)))

      (defun version
        (() 'v2))
      """)

      assert run([]) == {:ok, []}

      # If the module was not purged on recompilation, this would fail.
      assert :v2 == :purge_test.version()
    end)
  end

  test "continues even if one file fails to compile" do
    in_fixture(fn ->
      file = Path.absname("src/foo.lfe")

      File.write!(file, """
      (defmodule foo
        (export (bar 0)))

      bar() -> bar.
      """)

      capture_io(fn ->
        assert {:error, [diagnostic]} = run([])

        assert %Mix.Task.Compiler.Diagnostic{
                 compiler_name: "lfe_lint",
                 file: ^file,
                 message: "unknown form",
                 position: 4,
                 severity: :error
               } = diagnostic
      end)

      assert File.regular?("_build/dev/lib/sample/ebin/tut4.beam")
      assert File.regular?("_build/dev/lib/sample/ebin/tut5.beam")
    end)
  end

  defp in_fixture(function) do
    dest = Path.expand("../tmp", __DIR__)
    flag = String.to_charlist(dest)

    File.rm_rf!(dest)
    File.mkdir_p!(dest)
    File.cp_r!(@fixture_project, dest)

    get_path = :code.get_path()
    previous = :code.all_loaded()

    try do
      File.cd!(dest, function)
    after
      :code.set_path(get_path)

      for {mod, file} <- :code.all_loaded() -- previous,
          file == [] or (is_list(file) and :lists.prefix(flag, file)) do
        purge([mod])
      end
    end
  end

  defp purge(modules) do
    Enum.each(modules, fn m ->
      :code.purge(m)
      :code.delete(m)
    end)
  end

  defp delete_tmp_paths do
    "../tmp" |> Path.expand(__DIR__) |> File.rm_rf!()
  end
end
