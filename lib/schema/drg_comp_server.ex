defmodule DrgSite.DrgCompServer do
  use Ecto.Schema
  import Ecto.Changeset
  alias DrgSite.DrgCompServer

  schema "drg_comp_server" do
    field :href, :string
    field :file_name, :string
    field :version, :string
    field :datetime, :string
    field :change_log, :string
  end

  def changeset(%DrgCompServer{} = drg_comp_server, attrs) do
    drg_comp_server
    |> cast(attrs, [:href, :file_name, :version, :datetime, :change_log])
    |> validate_required([:href, :file_name, :version, :datetime, :change_log])
  end
end
