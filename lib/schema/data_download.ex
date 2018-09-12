defmodule DrgSite.DataDownload do
  use Ecto.Schema
  import Ecto.Changeset
  alias DrgSite.DataDownload
  alias DrgSite.Time

  schema "data_download" do
    field :title, :string
    field :time, :string
    field :notice, :string
    field :schedule, :string
    field :download, :string
    field :up_user, :string
    field :up_time, :string

    # timestamps
  end

  def changeset(%DataDownload{} = data_download, attrs) do
    attrs = add_time(attrs)
    data_download
    |> cast(attrs, [:title, :time, :notice, :schedule, :download, :up_user, :up_time])
    |> validate_required([:title, :time, :notice, :schedule, :download, :up_user, :up_time])
  end

  defp add_time(attrs) do
    attrs = Map.put(attrs, "up_time", Time.stime_local())
  end
end
