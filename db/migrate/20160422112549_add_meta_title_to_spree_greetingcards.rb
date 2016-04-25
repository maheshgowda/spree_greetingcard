class AddMetaTitleToSpreeGreetingcards < ActiveRecord::Migration
  def change
    change_table :spree_greetingcards do |t|
      t.string   :meta_title
    end
  end
end
