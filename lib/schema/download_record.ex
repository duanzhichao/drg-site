defmodule DrgSite.DownloadRecord do
  use Ecto.Schema
  import Ecto.Changeset
  alias DrgSite.DownloadRecord

  schema "download_record" do
    field :username, :string
    field :title, :string
    field :time, :string

    # timestamps
  end

  def changeset(%DownloadRecord{} = download_record, attrs) do
    download_record
    |> cast(attrs, [:username, :title, :time])
    |> validate_required([:username, :title, :time])
  end
end
