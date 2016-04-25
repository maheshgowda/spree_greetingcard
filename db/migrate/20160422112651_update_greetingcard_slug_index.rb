class UpdateGreetingcardSlugIndex < ActiveRecord::Migration
  def change
    remove_index :spree_greetingcards, :slug if index_exists?(:spree_greetingcards, :slug)
    add_index :spree_greetingcards, :slug, unique: true
  end
end
