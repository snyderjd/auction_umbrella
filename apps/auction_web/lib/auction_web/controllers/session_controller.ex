defmodule AuctionWeb.SessionController do
  use AuctionWeb, :controller

  # Renders the new template for a session
  def new(conn, _params) do
    render(conn, "new.html")
  end

  # Look up username and password. If found, store user_id in the session to create a new session
  # If not found, display error message and re-render the login form
  def create(conn, %{"user" => %{"username" => username, "password" => password}}) do
    case Auction.get_user_by_username_and_password(username, password) do
      %Auction.User{} = user ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Successfully logged in")
        |> redirect(to: Routes.user_path(conn, :show, user))
      _ ->
        conn
        |> put_flash(:error, "That username and password combination cannot be found")
        |> render("new.html")
    end
  end

end
