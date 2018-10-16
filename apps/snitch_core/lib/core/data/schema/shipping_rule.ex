defmodule Snitch.Data.Schema.ShippingRule do
  @moduledoc """
  Models the rules to be used while calculating shipping cost for
  a shipping category.
  """

  use Snitch.Data.Schema

  alias Snitch.Data.Schema.{ShippingCategory, ShippingRuleIdentifier}

  @type t :: %__MODULE__{}

  schema "snitch_shipping_rules" do
    field(:lower_limit, :decimal)
    field(:upper_limit, :decimal)
    field(:shipping_cost, Money.Ecto.Composite.Type)
    field(:active?, :boolean, default: false)

    # associations
    belongs_to(:identifier, ShippingRuleIdentifier)
    belongs_to(:category, ShippingCategory)

    timestamps()
  end

  @required_fields ~w(identifier_id category_id rate)a
  @optional_fields ~w(field_from field_to)a ++ @required_fields

  def changeset(%__MODULE__{} = rule, params) do
    rule
    |> cast(params, @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:identifier_id)
    |> foreign_key_constraint(:category_id)
  end
end
