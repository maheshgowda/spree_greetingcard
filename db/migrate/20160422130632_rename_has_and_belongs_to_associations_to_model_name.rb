class RenameHasAndBelongsToAssociationsToModelName < ActiveRecord::Migration
  def change
    {
      'spree_greetingcards_promotion_rules' => 'spree_greetingcard_promotion_rules',
    }.each do |old_name, new_name|
      rename_table old_name, new_name
    end
  end
end
