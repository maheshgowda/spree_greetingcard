class CreateGreetingcardProperties < ActiveRecord::Migration
  def change
    create_table :spree_greetingcard_properties do |t|
      t.string     :value
      t.references :greetingcard
      t.references :property
      t.timestamps null: false
    end

    add_index :spree_greetingcard_properties, [:greetingcard_id], :name => 'index_greetingcard_properties_on_greetingcard_id'

  end
end
