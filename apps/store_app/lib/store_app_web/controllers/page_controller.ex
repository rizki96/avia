defmodule StoreAppWeb.PageController do
  use StoreAppWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", welcome_text: "Welcome to Phoenix!")
  end
end
