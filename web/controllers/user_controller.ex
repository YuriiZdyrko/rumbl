defmodule Rumbl.UserController do

  alias Rumbl.User

  use Rumbl.Web, :controller

  plug :authenticate when action in [:index, :show]

  def index(conn, _params) do
    # case authenticate(conn) do
    #   %Plug.Conn{halted: true} = conn ->
    #     conn
    #   conn ->
    #     users = Repo.all(User)
    #     render conn, "index.html", users: users
    # end
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
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Rumbl.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  # defp authenticate(conn) do
  #   if conn.assigns.current_user do
  #     conn
  #   else
  #     conn
  #     |> put_flash(:error, "You must be logged in to access that page")
  #     |> redirect(to: page_path(conn, :index))
  #     |> halt()
  #   end
  # end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end

end
