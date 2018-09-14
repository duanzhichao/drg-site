defmodule DrgSite.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias DrgSite.User
  alias DrgSite.Time
  alias Comeonin.Bcrypt

  schema "web_user" do
    field :username, :string
    field :hashpw, :string
    field :org_code, :string
    field :org_name, :string
    field :phone, :string
    field :address, :string
    field :person, :string
    field :time, :string
    field :email, :string
    field :type, :boolean, default: false
    field :admin, :boolean, default: false
    field :update_pass, :boolean, default: false

    # timestamps
  end

  def changeset(%User{} = user, attrs) do
    attrs = password(attrs)
    user
    |> cast(attrs, [:username, :hashpw, :org_code, :org_name, :phone, :address, :person, :time, :email, :type, :admin, :update_pass])
    |> validate_required([:username, :hashpw, :phone, :address, :time, :email, :type, :admin, :update_pass])
  end

  defp password(attrs) do
    attrs = Map.put(attrs, "time", Time.stime_local())
    case Map.get(attrs, "password") do
      nil -> attrs
      x -> Map.put(attrs, "hashpw", Bcrypt.hashpwsalt(x))
    end
  end

end
