defmodule DrgSite.ImgUpload do
  use Ecto.Schema
  import Ecto.Changeset
  alias DrgSite.ImgUpload

  schema "img_upload" do
    field :name, :string
    field :path, :string

    timestamps
  end

  def changeset(%ImgUpload{} = img_upload, attrs) do
    img_upload
    |> cast(attrs, [:name, :path])
    |> validate_required([:name, :path])
  end
end
