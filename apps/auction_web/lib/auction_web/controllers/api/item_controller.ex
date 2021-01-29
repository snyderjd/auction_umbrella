defmodule AuctionWeb.Api.ItemController do
  use AuctionWeb, :controller

  # Gets the list of items
  def index(conn, _params) do
    items = Auction.list_items()
    render(conn, "index.json", items: items)
  end

  # Gets a single item by its id
  def show(conn, %{"id" => id}) do
    item = Auction.get_item_with_bids(id)
    render(conn, "show.json", item: item)
  end

end
