defmodule AuctionTest do
  use ExUnit.Case
  alias Auction.{Item, Repo}
  doctest Auction

  # setup takes a block as its argument and runs that block before each and every associated test
  setup do
    # checkout will "check out" a connection from the Sandbox pool of connections
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  describe "list_items/0" do
    # Can have a setup block inside each describe block, which will run for each test in the describe block
    setup do
      {:ok, item1} = Repo.insert(%Item{title: "Item 1"})
      {:ok, item2} = Repo.insert(%Item{title: "Item 2"})
      {:ok, item3} = Repo.insert(%Item{title: "Item 3"})

      # This map will be passed in as an argument to the tests in this block
      %{items: [item1, item2, item3]}
    end

    # Pattern-matches the passed map and assigns it to an items variable for use in the test
    test "returns all Items in the database", %{items: items} do
      assert items == Auction.list_items()
    end
  end

end
