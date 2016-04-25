class RemoveOnDemandFromGreeetingcard < ActiveRecord::Migration
  def change
    remove_column :spree_greetingcards, :on_demand
  end
end
