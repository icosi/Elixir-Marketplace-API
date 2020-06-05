defmodule MarketplaceApi.Model.Product do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @required []
  @uniqueness []

  @primary_key {:product_id, :id, autogenerate: true}
  @derive {Jason.Encoder, only: [:product_id, :name, :category, :description, :price]}
  schema "products" do
    field(:name, :string)
    field(:category, :string)
    field(:description, :string)
    field(:price, :integer)
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :category, :description])
    |> validate_required(@required)
  end
end
