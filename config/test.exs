import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ex2048, Ex2048Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "ZtrPNF3xDJ8cfwjf0f932q+sbTG6ab5wjc6UUaupnMt6ix0Y9MStyiT/GYssS1GL",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
