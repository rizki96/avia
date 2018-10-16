defmodule Snitch.Data.Schema.ShippingRuleIdentifier do
  @moduledoc """
  Models the `idenitifier` that would be used in creating
  the shipping_rules
  """
  use Snitch.Data.Schema
  @type t :: %__MODULE__{}

  # fs -> free shipping
  # fsrp -> flat shipping rate for product
  # fiso -> fixed shipping for order
  # fsro -> free shipping on order above

  @codes ~w(fs fsrp fiso fsro)s

  schema "snitch_shipping_rule_identifiers" do
    field(:code, Ecto.Atom)
    field(:description, :string)

    timestamps()
  end

  @required_fields ~w(code)a
  @optional_fields ~w(description)a ++ @required_fields

  def changeset(%__MODULE__{} = identifier, params) do
    identifier
    |> cast(params, @optional_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:code, @codes)
    |> unique_constraint(:code)
  end

  def codes() do
    @codes
  end
end
