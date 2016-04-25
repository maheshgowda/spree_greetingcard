class CreateGreetingcardTaxons < ActiveRecord::Migration
  def change
    create_table :spree_greetingcards_taxons, :id => false do |t|
      t.references :greetingcard
      t.references :taxon
    end

    add_index :spree_greetingcards_taxons, [:greetingcard_id], :name => 'index_spree_greetingcards_taxons_on_greetingcard_id'
    add_index :spree_greetingcards_taxons, [:taxon_id],   :name => 'index_spree_greetingcards_taxons_on_taxon_id'
  end
end
