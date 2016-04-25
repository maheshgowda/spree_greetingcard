class CreateGreetingcardsPromotionRules < ActiveRecord::Migration
  def change
    
    return if table_exists?(:spree_greetingcards_promotion_rules)
    
    create_table :spree_greetingcards_promotion_rules, :id => false, :force => true do |t|
      t.references :greetingcard
      t.references :promotion_rule
    end

    add_index :spree_greetingcards_promotion_rules, [:greetingcard_id], :name => 'index_greetingcards_promotion_rules_on_greetingcard_id'
    add_index :spree_greetingcards_promotion_rules, [:promotion_rule_id], :name => 'index_greetingcards_promotion_rules_on_promotion_rule_id'

  end
end
