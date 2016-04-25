class RemoveNotNullConstraintFromGreetingcardsOnHand < ActiveRecord::Migration
  def up
    change_column :spree_greetingcards, :count_on_hand, :integer, :null => true
  end

  def down
    change_column :spree_greetingcards, :count_on_hand, :integer, :null => false
  end
end
