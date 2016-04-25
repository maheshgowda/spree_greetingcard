class CreateGreetingcardOptionTypes < ActiveRecord::Migration
  def change
    create_table :spree_greetingcard_option_types do |t|
      t.integer    :position
      t.references :greetingcard
      t.references :option_type
      t.timestamps null: false
    end
  end
end
