class AddPrimaryToSpreeGreetingcardsTaxons < ActiveRecord::Migration
  def change
    add_column :spree_greetingcards_taxons, :id, :primary_key
  end
end
