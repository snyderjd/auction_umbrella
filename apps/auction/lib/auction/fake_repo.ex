defmodule Auction.FakeRepo do
  alias Auction.Item

  @items [
    %Item{
      id: 1,
      title: "My first item",
      description: "A tasty item sure to please",
      ends_at: ~N[2020-01-15 00:00:00]
    },
    %Item{
      id: 2,
      title: "WarGames Bluray",
      description: "The best computer movie of all time, now on Bluray!",
      ends_at: ~N[2020-01-20 00:00:00]
    },
    %Item{
      id: 3,
      title: "U2 - Achtung Baby on CD",
      description: "The sound of 4 men chopping down the Joshua Tree",
      ends_at: ~N[2020-01-20 00:00:00]
    },
    %Item{
      id: 4,
      title: "Coffee Cup",
      description: "Black coffee cup that holds coffee very well - no leaks",
      ends_at: ~N[2020-01-18 00:00:00]
    }
  ]

  def all(Item), do: @items

  def get!(Item, id) do
    Enum.find(@items, fn(item) -> item.id === id end)
  end

  def get_by(Item, attrs) do
    # Iterate over all the items
    Enum.find(@items, fn(item) ->
      # Check if all the key-value pairs passed in via attrs match a kvp in the item
      Enum.all?(Map.keys(attrs), fn(key) ->
        Map.get(item, key) == attrs[key]
      end)
    end)
  end
end
