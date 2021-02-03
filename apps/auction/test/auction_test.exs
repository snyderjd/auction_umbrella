defmodule AuctionTest do
  use ExUnit.Case
  alias Auction.{Item, Repo}
  import Ecto.Query
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

  # Insert two items and make sure only get one back (the correct one)
  describe "get_item/1" do
    setup do
      {:ok, item1} = Repo.insert(%Item{title: "Item 1"})
      {:ok, item2} = Repo.insert(%Item{title: "Item 2"})
      %{items: [item1, item2]}
    end

    test "returns a single Item based on id", %{items: items} do
      item = Enum.at(items, 1)
      assert item == Auction.get_item(item.id)
    end
  end

  describe "insert_item/1" do
    test "adds an Item to the database" do
      # Assigns a query to a variable
      count_query = from i in Item, select: count(i.id)

      before_count = Repo.one(count_query)
      {:ok, _item} = Auction.insert_item(%{title: "test item"})

      # Re-run the query to make sure there's an additional item now
      assert Repo.one(count_query) == before_count + 1
    end

    test "the Item in the database has the attributes provided" do
      attrs = %{title: "test item", description: "test description"}
      {:ok, item} = Auction.insert_item(attrs)
      assert item.title == attrs.title
      assert item.description == attrs.description
    end

    test "it returns an error on error" do
      assert {:error, _changeset} = Auction.insert_item(%{foo: :bar})
    end
  end

end
