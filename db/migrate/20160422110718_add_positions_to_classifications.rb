class AddPositionsToClassifications < ActiveRecord::Migration
  def change
    add_column :spree_greetingcards_taxons, :position, :integer
  end
end
