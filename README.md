# Mix LFE Compiler

A very simple Mix task that compiles LFE (lisp (flavoured (erlang))).

It is a Mix compiler which uses the Erlang Mix compiler.

Lisp is a great language to get into the functional way of thinking and LFE is Lisp 2+ which runs on the greatest platform (personal opinion).
Elixir's Mix is a great (or the greatest) configuration/package/build manager, so why not use it to compile LFE?
Also Elixir developers should try LFE! This little project has the purpose to make that easier.

## Installation

Install the Mix plugin for LFE if it isn't installed already:

```
mix archive.install https://github.com/meddle0x53/mix_lfe_new/releases/download/v0.1.0/mix_lfe_new-0.1.0.ez
```

You can create a LFE project with:

```
mix lfe.new <project_name>
```

The project uses the rebar3 `lfe` package to compile LFE source files, so the following will be necessary:

1. Navigate to the new project root.
2. Run `mix lfe.deps.setup`.
3. Now LFE code, located in the `src` folder of the project can be compiled with `mix compile`. You'll be able to use the compiled modules with `iex -S mix`.

To use the compiled modules with the LFE REPL, you can run:

```
./deps/lfe/bin/lfe -pa _build/dev/lib/*/ebin
```

The project can be created and set up in one command like this:

```
mix lfe.new <project_name> --setup
```

## Using it for running tests

The compiler can compile and run [ltest](https://github.com/lfex/ltest) tests.
Just put all the tests in the `test` folder of the project and run:

```
mix lfe.test
```

Works with umbrella applications, meaning that some of applications in the umbrella can be LFE ones.

## Example projects

In progress...

## TODO

The tests of this project mirror the ones for the Erlang Mix compiler.
For now the source is very simple and uses  an [idea](https://github.com/elixir-lang/elixir/blob/e1c903a5956e4cb9075f0aac00638145788b0da4/lib/mix/lib/mix/compilers/erlang.ex#L20) from the Erlang Mix compiler.
All works well, but requires some manual work and doesn't support LFE compiler fine tuning, so that's what we'll be after next.

1. Make it possible to add options when running `mix lfe.test`. Work on making stable versions by using another test runner/library or contacting the `ltest` maintainers.
2. Pass more options to the LFE compiler, using mix configuration.
3. More and more examples.
4. A mix task or binary running the LFE REPL in the context of the compiled artifacts.
5. Add CI to this project.

## License

Same as Elixir.
