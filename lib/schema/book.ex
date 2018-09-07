defmodule DrgSite.Book do
  use Ecto.Schema
  import Ecto.Changeset
  alias DrgSite.Book

  schema "book" do
    field :num, :integer
    field :name, :string
    field :author, :string
    field :from, :string
    field :type, :string

    # timestamps
  end

  def changeset(%Book{} = book, attrs) do
    book
    |> cast(attrs, [:num, :name, :author, :from, :type])
    |> validate_required([:num, :name, :author, :from, :type])
  end
end
