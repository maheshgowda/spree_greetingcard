class RemoveDiscontinuedFromGreetingcards < ActiveRecord::Migration
  def change
    remove_column :spree_greetingcards, :discontinue_on, :datetime
  end
end
