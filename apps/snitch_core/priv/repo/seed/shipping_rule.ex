defmodule Snitch.Seed.ShippingRules do
  @moduledoc false

  alias Snitch.Data.Schema.{
    ShippingRule,
    ShippingRuleIdentifier,
    ShippingCategory
  }

  alias Snitch.Core.Tools.MultiTenancy.Repo

  @shipping_rule_identifier %{
    code: nil,
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  }

  @shipping_rule %{}

  def seed!() do
    all_identifiers = seed_shipping_rule_identifiers()
    all_categories = Repo.all(ShippingCategory)
    seed_shipping_rules(all_identifiers, all_categories)
  end

  defp seed_shipping_rule_identifiers() do
    codes = ShippingRuleIdentifier.codes()

    identifiers =
      Enum.map(
        codes,
        fn code ->
          %{@shipping_rule_identifier | code: code}
        end
      )

    {_, identifiers} =
      Repo.insert_all(ShippingRuleIdentifier, identifiers, on_conflict: :nothing, returning: true)

    identifiers
  end

  def seed_shipping_rules(identifiers, categories) do
  end
end
