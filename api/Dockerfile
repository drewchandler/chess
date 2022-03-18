FROM elixir:1.9.4
WORKDIR /app
RUN mix do local.hex --force, local.rebar --force
ADD mix.exs mix.lock /app/
RUN mix do deps.get, deps.compile
ADD . /app
CMD mix phx.server
