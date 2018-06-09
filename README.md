# Mix LFE Compiler

A very simple Mix task that compiles LFE (lisp (flavoured (erlang))).

It is a Mix compiler which uses the Erlang Mix compiler.

Lisp is a great language to get into the functional way of thinking and LFE is Lisp 2+ which runs on the greatest platform (personal opinion).
Elixir's Mix is a great (or the greatest) configuration/package/build manager, so why not use it to compile LFE?
Also Elixir developers should try LFE! This little project has the purpose to make that an easier.

## Installation

You can create a Mix project with `mix new <project_name>` and add this as dependency:

```elixir
def deps do
  [
    {:mix_lfe, "~> 0.1.0"}
  ]
end
```

The project uses the rebar3 `lfe` package to compile LFE source files, so the following will be necessary:

1. Navigate to the new project root.
2. Run `mix deps.get`.
3. Run `mix local.rebar` (if you don't have rebar3 installed).
4. Compile LFE : `(cd deps/lfe && ~/.mix/rebar3 compile)`. You can replace `~/.mix/rebar3` here with the location it is installed on your machine.
5. Create a `src` folder and add your `*.lfe` sources there.
6. Run `mix compile.lfe` to compile them. Now you'll be able to use the compiled modules with `iex -S mix`.

To use the compiled modules with the LFE REPL, you can run:

```bash
./deps/lfe/bin/lfe -pa _build/dev/lib/*/ebin
```

Also if you want to just run `mix compile` add `compilers: Mix.compilers() ++ [:lfe]` to the list returned by `project/0` which is defined in your `mix.exs`.

## Example projects

TODO

## TODO

The tests of this project mirror the ones for the Erlang Mix compiler.
For now the source is very simple and uses  an [idea](https://github.com/elixir-lang/elixir/blob/e1c903a5956e4cb9075f0aac00638145788b0da4/lib/mix/lib/mix/compilers/erlang.ex#L20) from the Erlang Mix compiler.
All works well, but requires some manual work and doesn't support LFE compiler fine tunning, so that's what we'll be after next.

1. Add task for running LFE tests. What kind of tests? Will see...
2. Automate the installation & setup process in a way. Maybe by using something similar to the Phoenix generator tasks.
3. Pass more options to the LFE compiler, using mix configuration.
4. Use LFE syntax for configuration (not sure this is needed, really).
5. More and more examples.
6. A mix task or binary running the LFE REPL in the context of the compiled artifacts.
7. Add CI to this project.

## License

Same as Elixir.
