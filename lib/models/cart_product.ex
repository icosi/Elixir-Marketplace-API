defmodule MarketplaceApi.Model.CartProduct do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @required []
  @uniqueness []

  @primary_key {:relation_id, :id, autogenerate: true}
  schema "cart_product_relation" do
    field(:cart_id, :integer)
    field(:product_id, :integer)
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:cart_id, :product_id])
    |> validate_required(@required)
  end
end
