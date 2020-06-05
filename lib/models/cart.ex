defmodule MarketplaceApi.Model.Cart do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @required []
  @uniqueness []

  @primary_key {:cart_id, :id, autogenerate: true}
  schema "carts" do
    field(:user_id, :integer)
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:user_id])
    |> validate_required(@required)
  end
end
