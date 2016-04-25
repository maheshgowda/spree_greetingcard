class AddAnyMissingIndexes < ActiveRecord::Migration
  def change
    add_index :spree_greetingcard_option_types, :option_type_id
    add_index :spree_greetingcard_option_types, :greetingcard_id
    add_index :spree_greetingcards_taxons, :position
  end
end
