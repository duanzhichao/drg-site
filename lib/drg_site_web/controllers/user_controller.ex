defmodule DrgSiteWeb.UserController do
  use DrgSiteWeb, :controller
  alias DrgSite.User
  alias DrgSite.Page
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
            case user.update_pass do
              true -> conn = put_session(conn, :user, Map.put(user, :login, true))
              _ -> conn = put_session(conn, :user, Map.put(user, :login, false))
            end
            render(conn, "login.json", user: user, login: true)
          false ->
            conn = put_session(conn, :user, %{login: false, username: ""})
            render(conn, "login.json", user: user, login: false)
        end
    end
  end

  def validate_username(conn, %{"username" => username}) do
    user = Repo.get_by(User, username: username)
    [user, ishave] =
      case user do
        nil -> [%User{}, false]
        _ -> [user, true]
      end
    render(conn, "validate.json", user: user, ishave: ishave)
  end

  def index(conn, %{"type" => type, "page" => page, "limit" => limit, "search" => search}) do
    skip = Page.skip(page, limit)
    query = from(p in User)|>where([p], p.type == ^type)
    query =
      case search do
        "" -> query
        _ ->
          search = "%#{search}%"
          from p in User, where: p.type == ^type and (like(p.username, ^search) or like(p.org_code, ^search) or like(p.org_name, ^search) or like(p.phone, ^search) or like(p.address, ^search) or like(p.person, ^search) or like(p.email, ^search))
      end
    count = query
      |>select([p], count(p.id))
      |>Repo.all
      |>hd
    [page_num, page_list, _count] = Page.page_list(page, count, limit)
    user = query
      |>limit([p], ^limit)
      |>offset([p], ^skip)
      |>Repo.all
    render(conn, "index.json", user: user, page: page, page_list: page_list)
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
    IO.inspect changeset
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
