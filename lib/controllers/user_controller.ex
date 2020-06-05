defmodule MarketplaceApi.Controller.User do
  @moduledoc """
  Wallet Api controller
  """
  import Plug.Conn
  alias MarketplaceApi.Repo
  alias MarketplaceApi.Model.User
  alias MarketplaceApi.Model.Cart
  alias MarketplaceApi.Model.Product
  alias MarketplaceApi.Model.CartProduct

  require Logger
  import Ecto.Query
  import Ecto

  # alias BetCore.Service.Wallet
  # alias BetCore.Hash
  # alias Hub88.RepoRW
  # alias Hub88.RepoRO
  # alias Hub88.Model.Transaction

  def new_user(conn) do
    params = conn.params

    user_id = create_user(params["name"], params["last_name"])

    resp = %{
      user_id: user_id
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(resp))
  end

  def new_product(conn) do
    params = conn.params

    product =
      create_product(params["name"], params["category"], params["description"], params["price"])

    resp = %{
      product: product
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(resp))
  end

  def get_products(conn) do
    params = conn.params

    products = get_all_products()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(products))
  end

  def get_cart(conn) do
    params = conn.params

    cart = get_cart_from_user(params["user_id"])
    products_id = get_all_products_from_cart(cart.cart_id)
    cart_products = get_products_from_list(products_id)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(cart_products))
  end

  def add_product_to_cart(conn) do
    params = conn.params

    status =
      case insert_product_to_cart(params["user_id"], params["product_id"]) do
        %{} -> "Cart updated"
        _ -> "Product NOT inserted"
      end

    resp = %{
      status: status
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(resp))
  end

  #################
  #               #
  #    PRIVATE    #
  #   FUNCTIONS   #
  #               #
  #################

  def get_cart_from_user(id) do
    Repo.get_by!(Cart, user_id: id)
  end

  def get_product_by_name(name) do
    Repo.get_by!(Product, name: name)
  end

  def get_product_by_id(id) do
    Repo.get_by!(Product, product_id: id)
  end

  def insert_product_to_cart(product_id, cart_id) do
    cart_product_changeset =
      CartProduct.changeset(%CartProduct{}, %{
        product_id: product_id,
        cart_id: cart_id
      })

    cart_product_insert = Repo.insert!(cart_product_changeset)
  end

  def get_all_products_from_cart(cart_id) do
    products =
      CartProduct
      |> where(cart_id: ^cart_id)
      |> Repo.all()

    products_id = Enum.map(products, fn x -> x.product_id end)
  end

  def get_all_users do
    Repo.all(User)
  end

  def get_all_products do
    Repo.all(Product)
  end

  def get_product_by_category(category) do
    products =
      Product
      |> where(category: ^category)
      |> Repo.all()
  end

  # def get_product_by_name(name) do
  #   products =
  #     Product
  #     |> where(name: ^name)
  #     |> Repo.all()
  # end

  def create_user(name, last_name) do
    user_changeset =
      User.changeset(%User{}, %{
        name: name,
        last_name: last_name
      })

    user_insert = Repo.insert!(user_changeset)

    cart_changeset =
      Cart.changeset(%Cart{}, %{
        user_id: user_insert.user_id
      })

    cart_insert = Repo.insert!(cart_changeset)
    user_insert.user_id
  end

  def create_product(name, category, description, price) do
    product_changeset =
      Product.changeset(%Product{}, %{
        name: name,
        category: category,
        description: description,
        price: price
      })

    product_insert = Repo.insert!(product_changeset)
  end

  def get_products_from_list(ids) do
    Enum.map(ids, fn x ->
      get_product_by_id(x)
    end)
  end
end
