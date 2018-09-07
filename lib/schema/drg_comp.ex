defmodule DrgSite.DrgComp do
  use Ecto.Schema
  import Ecto.Changeset
  alias DrgSite.DrgComp

  schema "drg_comp" do
    field :log, :string
    field :error_log, :string
    timestamps
  end

  def changeset(%DrgComp{} = drg_comp, attrs) do
    drg_comp
    |> cast(attrs, [:log, :error_log])
    |> validate_required([:log, :error_log])
  end
end
