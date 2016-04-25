class ChangeMetaDescriptionOnSpreeGreetingcardsToText < ActiveRecord::Migration
  def change
    change_column :spree_greetingcards, :meta_description, :text, :limit => nil
  end
end
