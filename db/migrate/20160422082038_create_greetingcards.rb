class CreateGreetingcards < ActiveRecord::Migration
  def change
    create_table :spree_greetingcards do |t|
      t.string     :name,                 :default => '', :null => false
      t.text       :description
      t.datetime   :available_on
      t.datetime   :deleted_at
      t.string     :permalink
      t.string     :meta_description
      t.string     :meta_keywords
      t.references :tax_category
      t.references :shipping_category
      t.integer    :count_on_hand,        :default => 0,  :null => false
      t.timestamps null: false
    end

    add_index :spree_greetingcards, [:available_on], :name => 'index_spree_greetingcards_on_available_on'
    add_index :spree_greetingcards, [:deleted_at],   :name => 'index_spree_greetingcards_on_deleted_at'
    add_index :spree_greetingcards, [:name],         :name => 'index_spree_greetingcards_on_name'
    add_index :spree_greetingcards, [:permalink],    :name => 'index_spree_greetingcards_on_permalink'
  end
end
