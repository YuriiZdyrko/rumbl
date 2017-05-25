defmodule Rumbl.UserController do
  use Rumbl.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", users: Rumbl.Repo.all(Rumbl.User)
  end

  def show(conn, %{"id" => id}) do
    render conn, "show.html", user: Rumbl.Repo.get(Rumbl.User, id)
  end
end
