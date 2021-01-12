defmodule AuctionWeb.ItemController do
  use AuctionWeb, :controller

  # Return the list of items for GET to /items
  def index(conn, _params) do
    items = Auction.list_items()
    render(conn, "index.html", items: items)
  end

  # Returns a single item for GET to /items/:id
  def show(conn, %{"id" => id}) do
    item = Auction.get_item(id)
    render(conn, "show.html", item: item)
  end

  # Render form to create a new item for GET to /items/new
  def new(conn, _params) do
    item = Auction.new_item()
    render(conn, "new.html", item: item)
  end

  def create(conn, %{"item" => item_params}) do
    {:ok, item} = Auction.insert_item(item_params)
    redirect(conn, to: Routes.item_path(conn, :show, item))
  end

end
