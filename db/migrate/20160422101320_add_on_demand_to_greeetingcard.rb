class AddOnDemandToGreeetingcard < ActiveRecord::Migration
  def change
    add_column :spree_greetingcards, :on_demand, :boolean, :default => false
  end
end
