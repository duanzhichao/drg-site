defmodule DrgSite.TechnicalDownload do
  use Ecto.Schema
  import Ecto.Changeset
  alias DrgSite.TechnicalDownload

  schema "technical_download" do
    field :file_type, :string
    field :file_name, :string
    field :up_user, :string
    field :up_time, :string

    # timestamps
  end

  def changeset(%TechnicalDownload{} = technical_download, attrs) do
    technical_download
    |> cast(attrs, [:file_type, :file_name, :up_user, :up_time])
    |> validate_required([:file_type, :file_name, :up_user, :up_time])
  end

end
