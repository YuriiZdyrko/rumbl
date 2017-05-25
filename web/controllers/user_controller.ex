defmodule Rumbl.UserController do

  alias Rumbl.User

  use Rumbl.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", users: Rumbl.Repo.all(User)
  end

  def show(conn, %{"id" => id}) do
    render conn, "show.html", user: Rumbl.Repo.get(User, id)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
