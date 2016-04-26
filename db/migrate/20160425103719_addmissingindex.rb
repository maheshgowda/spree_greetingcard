class Addmissingindex < ActiveRecord::Migration
  def change
    add_index "spree_greetingcard_properties", ["position"], name: "index_spree_greetingcard_properties_on_position", using: :btree
  end
end
