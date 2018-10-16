use Mix.Config

# Configure your database
config :snitch_core, Snitch.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "Rizki",
  password: "posttest",
  database: "snitch_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :snitch_core, :defaults_module, Snitch.Tools.DefaultsMock
config :snitch_core, :user_config_module, Snitch.Tools.UserConfigMock

config :logger, level: :info

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8
