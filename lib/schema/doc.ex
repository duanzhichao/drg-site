defmodule DrgSite.Doc do
  use Ecto.Schema
  import Ecto.Changeset
  alias DrgSite.Doc

  schema "doc" do
    field :doc_title, :string
    field :doc_time, :string
    field :doc_number, {:array, :string}
    field :doc_from, :string
    field :doc_type, :string
    field :doc_object, {:array, :string}
    field :doc_content, {:array, :string}
    field :doc_contact, {:array, :string}
    field :doc_inscribe, {:array, :string}
    field :ishave_file, :boolean, default: false
    field :file, {:array, :string}
    field :browse_volume, :integer
    field :up_user, :string
    field :up_time, :string

    # timestamps
  end

  def changeset(%Doc{} = doc, attrs) do
    attrs = add_time(attrs)
    doc
    |> cast(attrs, [:doc_title, :doc_time, :doc_number, :doc_from, :doc_type, :doc_object, :doc_content, :doc_contact, :doc_inscribe, :ishave_file, :file, :browse_volume, :up_user, :up_time])
    |> validate_required([:doc_title, :browse_volume, :up_user, :up_time])
  end

  defp add_time(attrs) do
    Map.put(attrs, "up_time", DrgSite.Time.stime_local())
  end
end
