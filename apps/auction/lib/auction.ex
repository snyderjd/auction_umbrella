defmodule Auction do
  alias Auction.{Item, User, Password, Bid}
  import Ecto.Query

  @repo Auction.Repo

  # Set of public interface functions that allow you to easily create, read, update, delete, etc
  # without having to know about the details of the database

  # ---------- Items ----------
  def insert_item(attrs) do
    %Item{}
    |> Item.changeset(attrs)
    |> @repo.insert()
  end

  def delete_item(%Auction.Item{} = item), do: @repo.delete(item)

  def list_items do
    @repo.all(Item)
  end

  def get_item(id) do
    @repo.get!(Item, id)
  end

  def get_item_with_bids(id) do
    id
    |> get_item()
    |> @repo.preload(bids: from(b in Bid, order_by: [desc: b.inserted_at]))
    |> @repo.preload(bids: [:user])
  end

  def get_item_by(attrs) do
    @repo.get_by(Item, attrs)
  end

  def update_item(%Auction.Item{} = item, updates) do
    item
    |> Item.changeset(updates)
    |> @repo.update()
  end

  def edit_item(id) do
    get_item(id)
    |> Item.changeset()
  end

  def new_item, do: Item.changeset(%Item{})

  # ---------- Users ----------
  def get_user(id), do: @repo.get!(User, id)

  def new_user, do: User.changeset_with_password(%User{})

  def insert_user(params) do
    %User{}
    |> User.changeset_with_password(params)
    |> @repo.insert
  end

  @doc """
  Retrieves a User from the database matching the provided username and password

  ## Return Values

  Depending on what is found in the database, two different values could be returned:
  * an `Auction.User` struct: An `Auction.User` record was found that matched the `username` and `password that was provided`
  * `false`: No `Auction.User` could be found with the provided `username` and `password`

  You can then use the returned value to determine whether or not the User is authorized in your application.
  If an `Auction.User` is _not_ found based on `username`, the computational work of hashing a password is still done
  """
  def get_user_by_username_and_password(username, password) do
    with user when not is_nil(user) <- @repo.get_by(User, %{username: username}),
      true <- Password.verify_with_hash(password, user.hashed_password) do
        user
    else
      _ -> Password.dummy_verify
    end
  end

  # ---------- Bids ----------
  def insert_bid(params) do
    %Bid{}
    |> Bid.changeset(params)
    |> @repo.insert()
  end

  def new_bid, do: Bid.changeset(%Bid{})

  def get_bids_for_user(user) do
    query =
      from b in Bid,
      where: b.user_id == ^user.id,
      order_by: [desc: :inserted_at],
      preload: :item,
      limit: 10
    @repo.all(query)
  end

end
