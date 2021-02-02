use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :auction, Auction.Repo,
  username: "snyderjd",
  password: "postgres",
  database: "auction_test",
  hostname: "localhost",
  port: "5432",
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :info
