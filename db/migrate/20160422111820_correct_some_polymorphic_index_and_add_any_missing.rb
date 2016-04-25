class CorrectSomePolymorphicIndexAndAddAnyMissing < ActiveRecord::Migration
  def change
    add_index :spree_greetingcard_option_types, :position
    add_index :spree_greetingcards, :shipping_category_id
    add_index :spree_greetingcards, :tax_category_id
  end
end
