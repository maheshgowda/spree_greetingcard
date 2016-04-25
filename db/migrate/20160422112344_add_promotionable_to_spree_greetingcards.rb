class AddPromotionableToSpreeGreetingcards < ActiveRecord::Migration
  def change
    add_column :spree_greetingcards, :promotionable, :boolean, default: true
  end
end
