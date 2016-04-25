class RemoveDuplicatedIndexeFromMultiColumns < ActiveRecord::Migration
  def change
    remove_index :spree_greetingcards_promotion_rules, name: "index_greetingcards_promotion_rules_on_promotion_rule_id"
  end
end
