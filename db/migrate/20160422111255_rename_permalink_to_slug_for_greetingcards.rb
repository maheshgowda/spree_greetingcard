class RenamePermalinkToSlugForGreetingcards < ActiveRecord::Migration
  def change
    rename_column :spree_greetingcards, :permalink, :slug
  end
end
