class AddMissingIndexs < ActiveRecord::Migration
  def change
    add_index "spree_greetingcard_properties", ["property_id"], name: "index_spree_greetingcard_properties_on_property_id", using: :btree
  end
end
