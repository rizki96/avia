defmodule AdminAppWeb.ProductView do
  use AdminAppWeb, :view

  alias Snitch.Data.Schema.{ShippingCategory, Variation}
  alias Snitch.Core.Tools.MultiTenancy.Repo

  alias Snitch.Data.Model.{Product, ProductProperty, Property, StockItem}
  alias Snitch.Data.Schema
  import Ecto.Query

  @currencies ["USD", "INR"]
  @dummy_image_url "/images/empty-img.png"
  @search_keys ["rummage", "search", "state", "search_term"]
  @sort_field_keys ["rummage", "sort", "field"]
  @sort_order_keys ["rummage", "sort", "order"]

  def themes_options(product) do
    Enum.map(product.taxon.variation_themes, fn theme -> {theme.name, theme.id} end)
  end

  # TODO This needs to be replaced and we need a better system to identify
  # the type of product.
  def is_parent_product(product_id) when is_binary(product_id) do
    query =
      from(
        p in "snitch_product_variants",
        where: p.parent_product_id == ^(product_id |> String.to_integer()),
        select: fragment("count(*)")
      )

    count = Repo.one(query)
    count > 0
  end

  def can_add_variant(product) do
    has_themes(product) && !is_child_product(product)
  end

  def has_themes(product) do
    length(product.taxon.variation_themes) > 0
  end

  defp is_child_product(product) do
    query = from(c in Variation, where: c.child_product_id == ^product.id)
    count = Repo.aggregate(query, :count, :id)
    count > 0
  end

  def has_variants(product) do
    product.variants |> length > 0
  end

  def get_option_types(product) do
    variant = product.variants |> List.first()

    variant.options
    |> Enum.map(fn x -> x.option_type end)
  end

  def get_brand_options(brands) do
    Enum.map(brands, fn brand -> {brand.name, brand.id} end)
  end

  def get_amount(nil) do
    "0"
  end

  def get_amount(money) do
    money.amount
    |> Decimal.to_string(:normal)
    |> Decimal.round(2)
  end

  def get_taxon(conn) do
    conn.params["taxon"]
  end

  def get_currency_value(nil) do
    @currencies |> List.first()
  end

  def get_currency_value(money) do
    money.currency
  end

  # TODO This needs to fetched from config
  def get_currency() do
    @currencies
  end

  def get_image_url(image, product) do
    Product.image_url(image.name, product)
  end

  def get_product_display_image(product) do
    image = product.images |> List.first()

    case image do
      nil ->
        @dummy_image_url

      _ ->
        get_image_url(image, product)
    end
  end

  def get_variant_option(variants) do
    Enum.map(variants, fn variant -> {variant.name, variant.id} end)
  end

  def get_stock_locations_option(locations) do
    Enum.map(locations, fn location -> {location.name, location.id} end)
  end

  def get_shipping_category() do
    ShippingCategory
    |> order_by([sc], asc: sc.name)
    |> Ecto.Query.select([sc], {sc.name, sc.id})
    |> Repo.all()
  end

  def make_search_query_string(conn, column, expression, type, term) do
    query =
      "&rummage[search][#{column}][search_expr]=#{expression}&rummage[search][#{column}][search_type]=#{
        type
      }&rummage[search][#{column}][search_term]=#{term}"

    conn_query =
      load_query_string(conn, ["rummage", "sort"], ["rummage", "search"])
      |> Plug.Conn.Query.encode()

    conn.request_path <> "?" <> conn_query <> query
  end

  def make_sort_query_string(conn, column, order) do
    query = "&rummage[sort][field]=#{column}&rummage[sort][order]=#{order}"

    conn_query =
      load_query_string(conn, ["rummage", "search"], ["rummage", "sort"])
      |> Plug.Conn.Query.encode()

    conn.request_path <> "?" <> conn_query <> query
  end

  defp load_query_string(conn, get_list, pop_list) do
    if conn.query_params |> get_in(get_list) do
      conn.query_params |> pop_in(pop_list) |> elem(1)
    else
      Map.new()
    end
  end

  def selected_option(
        conn,
        option,
        order,
        return_string,
        list1 \\ @sort_field_keys,
        list2 \\ @sort_order_keys
      ) do
    if conn.query_params |> get_val(list1) == option &&
         conn.query_params |> get_val(list2) == order do
      " " <> return_string
    else
      ""
    end
  end

  def selected_radio(conn, option, return_string, list \\ @search_keys) do
    if conn.query_params |> get_val(list) == option do
      " " <> return_string
    else
      ""
    end
  end

  def count_on_hand(conn) do
    product_id = String.to_integer(conn.params["id"])

    case StockItem.with_active_stock_location(product_id) do
      [] ->
        # condition when product is created for the first time
        # and there are no stock items
        0

      [stock_item] ->
        stock_item.count_on_hand
    end
  end

  defp map_get(map, key) do
    map |> Map.get(key, Map.new())
  end

  defp get_val(map, [head | tail]) do
    map |> map_get(head) |> get_val(tail)
  end

  defp get_val(val, []) do
    val
  end

  def get_product_properties(product_id) when is_binary(product_id) do
    product_id |> ProductProperty.get_all_by_product() |> Repo.preload(:property)
  end

  def get_property_changeset(conn) do
    Schema.ProductProperty.create_changeset(%Schema.ProductProperty{}, %{})
  end

  def get_properties() do
    Property.get_formatted_list()
  end
end
