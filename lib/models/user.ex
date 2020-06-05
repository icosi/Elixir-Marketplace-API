defmodule MarketplaceApi.Model.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @required []
  @uniqueness []

  @derive {Jason.Encoder, only: [:user_id, :name, :last_name]}
  @primary_key {:user_id, :id, autogenerate: true}
  schema "users" do
    field(:name, :string)
    field(:last_name, :string)
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :last_name])
    |> validate_required(@required)
  end
end

# changeset = Hub88.Model.Rollback.changeset(%Hub88.Model.Rollback{}, %{external_transaction_id: "asf", account_id: "123", amount: 4455, status_id: 1})
