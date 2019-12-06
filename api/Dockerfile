FROM elixir:1.9.4
WORKDIR /app
RUN mix do local.hex --force, local.rebar --force
ADD mix.exs mix.lock /app/
RUN mix deps.get
ADD . /app
CMD mix phx.server
