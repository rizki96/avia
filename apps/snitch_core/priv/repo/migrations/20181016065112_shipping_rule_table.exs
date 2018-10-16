defmodule Snitch.Repo.Migrations.ShippingRuleTable do
  use Ecto.Migration

  def change do
    create table("snitch_shipping_rules") do
      add(:lower_limit, :decimal)
      add(:upper_limit, :decimal)
      add(:shipping_cost, String.to_atom("#{prefix()||"public"}.money_with_currency"))
      add(:active?, :boolean)
      add(:identifier_id, references("snitch_shipping_rule_identifiers", on_delete: :restrict))
      add(:category_id, references("snitch_shipping_categories", on_delete: :delete_all))
      timestamps()
    end
  end
end
