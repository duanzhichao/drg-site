defmodule DrgSiteWeb.UserController do
  use DrgSiteWeb, :controller
  alias DrgSite.User
  alias Comeonin.Bcrypt

  plug :scrub_params, "user" when action in [:create, :update]

  def login(conn, %{"user" => user}) do
    %{"username" => username, "password" => password} = user
    user = Repo.get_by(User, username: username)
    case user do
      nil ->
        conn = put_session(conn, :user, %{login: false, username: ""})
        render(conn, "login.json", user: %User{}, login: false)
      _ ->
        case Bcrypt.checkpw(password, user.hashpw) do
          true ->
            conn = put_session(conn, :user, Map.put(user, :login, true))
            render(conn, "login.json", user: user, login: true)
          false ->
            conn = put_session(conn, :user, %{login: false, username: ""})
            render(conn, "login.json", user: user, login: false)
        end
    end
  end

  def index(conn, %{"type" => type, "login" =>login, "username" => username, "password" => password, "email" => email, "phone" => phone, "skip" => skip}) do
    cond do
      login == "login" ->
        if (Repo.get_by(DrgSite.User, username: username)) do
          user = Repo.get_by(DrgSite.User, username: username)
          db_password = user.hashpw
          if (Bcrypt.checkpw(password, db_password)) do
            user = [user]
            render(conn, "index.json", user: user)
          else
            json conn, %{"login_fail" => true}
          end
        else
          json conn, %{"login_fail" => true}
        end
      login == "userlist" ->
        query=
        from user in User,
          where: user.type == ^type,
          limit: 10,
          offset: ^skip
        user = Repo.all(query)
        render(conn, "index.json", user: user)
      login == "changepassword" ->
        if (Repo.get_by(DrgSite.User, username: username)) do
          user = Repo.get_by(DrgSite.User, username: username)
          if (user.email == email and user.phone == phone) do
            user = [user]
            render(conn, "index.json", user: user)
          else
            json conn, %{"changepassword_fail" => true}
          end
        else
          json conn, %{"changepassword_fail" => true}
        end
    end
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DrgSiteWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)
    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DrgSiteWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end
end
