FROM elixir:1.13.3
WORKDIR /app
RUN apt-get update && apt-get install -y inotify-tools && rm -rf /var/lib/apt/lists/*
RUN mix do local.hex --force, local.rebar --force
ADD mix.exs mix.lock /app/
RUN mix do deps.get, deps.compile
ADD . /app
CMD mix phx.server
