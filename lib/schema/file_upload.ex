defmodule DrgSite.FileUpload do
  use Ecto.Schema
  import Ecto.Changeset
  alias DrgSite.FileUpload

  schema "file_upload" do
    field :name, :string
    field :path, :string
    field :time, :string
  end

  def changeset(%FileUpload{} = file_upload, attrs) do
    file_upload
    |> cast(attrs, [:name, :path, :time])
    |> validate_required([:name, :path, :time])
  end
end
