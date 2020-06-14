defmodule MarketplaceApi.Controller do
  import Plug.Conn
  alias MarketplaceApi.Repo
  alias MarketplaceApi.Model.User
  alias MarketplaceApi.Model.Cart
  alias MarketplaceApi.Model.Product
  alias MarketplaceApi.Model.CartProduct

  require Logger
  import Ecto.Query
  import Ecto

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
    # |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(products))
  end

  def get_product_by_id(conn) do
    params = conn.params

    product = priv_get_product_by_id(params["product_id"])

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(product))
  end

  def get_cart(conn) do
    params = conn.params

    cart = get_cart_from_user(params["user_id"])
    products_id = get_all_products_id_from_cart(cart.cart_id)
    cart_products = get_products_from_list(products_id)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(cart_products))
  end

  def add_product_to_cart(conn) do
    params = conn.params

    cart = get_cart_from_user(params["user_id"])
    IO.inspect(cart.cart_id)

    insert_product_to_cart(params["product_id"], cart.cart_id)

    resp = %{
      status: "Cart updated"
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(resp))
  end

  def checkout(conn) do
    params = conn.params

    cart = get_cart_from_user(params["user_id"])
    products_id = get_all_products_id_from_cart(cart.cart_id)
    cart_prices = get_all_prices_from_products_id(products_id)
    cart_sum = sum_list(cart_prices)

    clean_cart(cart.cart_id)

    resp = %{
      total: cart_sum
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

  def sum_list([]) do
    0
  end

  def sum_list([h | t]) do
    h + sum_list(t)
  end

  def clean_cart(cart_id) do
    products =
      CartProduct
      |> where(cart_id: ^cart_id)
      |> Repo.delete_all()
  end

  def get_cart_from_user(id) do
    Repo.get_by!(Cart, user_id: id)
  end

  def get_product_by_name(name) do
    Repo.get_by!(Product, name: name)
  end

  def priv_get_product_by_id(id) do
    Repo.get_by!(Product, product_id: id)
  end

  def priv_get_user_by_id(id) do
    Repo.get_by!(User, user_id: id)
  end

  def insert_product_to_cart(product_id, cart_id) do
    cart_product_changeset =
      CartProduct.changeset(%CartProduct{}, %{
        product_id: product_id,
        cart_id: cart_id
      })

    cart_product_insert = Repo.insert!(cart_product_changeset)
  end

  def get_all_products_id_from_cart(cart_id) do
    products =
      CartProduct
      |> where(cart_id: ^cart_id)
      |> Repo.all()

    products_id = Enum.map(products, fn x -> x.product_id end)
  end

  def get_all_prices_from_products_id(products_id) do
    prices =
      Enum.map(products_id, fn x ->
        product =
          Product
          |> where(product_id: ^x)
          |> Repo.one()

        product.price
      end)
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
      priv_get_product_by_id(x)
    end)
  end
end
