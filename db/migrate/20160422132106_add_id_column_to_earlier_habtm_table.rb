class AddIdColumnToEarlierHabtmTable < ActiveRecord::Migration
  def change
    add_column :spree_greetingcard_promotion_rules, :id, :primary_key
  end
end
