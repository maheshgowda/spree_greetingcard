class AddGreetingcardToSpreeVariants < ActiveRecord::Migration
  def change
    add_reference :spree_variants, :greetingcard, index: true, :name => 'index_spree_variants_on_greetingcard_id'
  end
end
