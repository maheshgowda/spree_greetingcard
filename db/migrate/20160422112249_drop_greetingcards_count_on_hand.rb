class DropGreetingcardsCountOnHand < ActiveRecord::Migration
  def change
    remove_column :spree_greetingcards, :count_on_hand
  end
end
