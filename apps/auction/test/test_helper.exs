# Can put any setup code you need to run before your tests in this file

ExUnit.start()

# Tells Ecto that you'd like to use the sandbox mode for a particular repo
Ecto.Adapters.SQL.Sandbox.mode(Auction.Repo, :manual)
