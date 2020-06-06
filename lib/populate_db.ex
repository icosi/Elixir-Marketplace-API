defmodule MarketplaceApi.PopulateDB do
  alias MarketplaceApi.Controller

  def generate_users(num_users) do
    Enum.each(1..num_users, fn x ->
      name = "Test"
      last_name = "Last"
      Controller.create_user(name, last_name)
    end)
  end

  def generate_products(num_products) do
    Enum.each(1..num_products, fn x ->
      name = "Test"
      category = "Last"
      description = "Last"
      price = 10

      Controller.create_product(name, category, description, price)
    end)
  end
end
