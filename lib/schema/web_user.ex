defmodule DrgSite.WebUser do
  use Ecto.Schema
  import Ecto.Changeset
  alias DrgSite.WebUser
  # alias Comeonin.Bcrypt

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

    # timestamps
  end

  def changeset(%WebUser{} = web_user, attrs) do
    web_user
    |> cast(attrs, [:username, :hashpw, :org_code, :org_name, :phone, :address, :person, :time, :email, :type, :admin])
    |> validate_required([:username, :hashpw, :org_code, :org_name, :phone, :address, :person, :time, :email, :type, :admin])
  end
end
