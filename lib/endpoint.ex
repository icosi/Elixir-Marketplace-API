defmodule MarketplaceApi.Endpoint do
  @moduledoc """
  A Plug responsible for logging request info, parsing request body's as JSON,
  matching routes, and dispatching responses.
  """
  use Plug.Router

  alias MarketplaceApi.Controller, as: C

  # Use plug logger for logging request information
  plug(Plug.Logger)

  # responsible for matching routes
  plug(:match)

  # Using Jason for JSON decoding
  # Note, order of plugs is important, by placing this _after_ the 'match' plug,
  # we will only parse the request AFTER there is a route match.
  plug(Plug.Parsers,
    parsers: [:json],
    json_decoder: Jason
  )

  # responsible for dispatching responses
  plug(:dispatch)

  post("/user/create", do: C.User.new_user(conn))
  post("/user/cart", do: C.User.get_cart(conn))
  post("/user/add_product", do: C.User.add_product_to_cart(conn))

  get("/product/all", do: C.User.get_products(conn))
  post("/product/new", do: C.User.new_product(conn))

  get "/status" do
    send_resp(conn, 200, Jason.encode!(%{status: "UP", front: "UP", version: "lib"}))
  end

  # A catchall route, 'match' will match no matter the request method,
  # so a response is always returned, even if there is no route to match.
  match _ do
    send_resp(conn, 404, "oops... Nothing to see here :(")
  end
end
