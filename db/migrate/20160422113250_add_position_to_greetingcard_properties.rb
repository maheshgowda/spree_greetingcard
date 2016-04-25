class AddPositionToGreetingcardProperties < ActiveRecord::Migration
  def change
    add_column :spree_greetingcard_properties, :position, :integer, :default => 0
  end
end
