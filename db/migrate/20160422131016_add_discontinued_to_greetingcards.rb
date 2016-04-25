class AddDiscontinuedToGreetingcards < ActiveRecord::Migration
  def up
    add_column :spree_greetingcards, :discontinue_on, :datetime, after: :available_on
    
    add_index :spree_greetingcards, :discontinue_on

    

    puts "Warning: This migration changes the meaning of 'deleted'. Before this change, 'deleted' meant greetingcards that were no longer being sold in your store. After this change, you can only delete a greetingcard or variant if it has not already been sold to a customer (a model-level check enforces this). Instead, you should use the new field 'discontinue_on' for greetingcards or variants which were sold in the past but no longer for sale. This fixes bugs when other objects are attached to deleted greetingcards and variants. (Even though acts_as_paranoid gem keeps the records in the database, most associations are automatically scoped to exclude the deleted records.) In thew meaning of 'deleted,' you can still use the delete function on greetingcards & variants which are *truly user-error mistakes*, specifically before an order has been placed or the items have gone on sale. You also must use the soft-delete function (which still works after this change) to clean up slug (greetingcard) and SKU (variant) duplicates. Otherwise, you should generally over ever need to discontinue greetingcards.

Data Fix: We will attempt to reverse engineer the old meaning of 'deleted' (no longer for sale) to the new database field 'discontinue_on'. However, since Slugs and SKUs cannot be duplicated on Greetingcards and Variants, we cannot gaurantee this to be foolproof if you have deteled Greetingcards and Variants that have duplicate Slugs or SKUs in non-deleted records. In these cases, we recommend you use the additional rake task to clean up your old records (see rake db:fix_orphan_line_items). If you have such records, this migration will leave them in place, preferring the non-deleted records over the deleted ones. However, since old line items will still be associated with deleted objects, you will still the bugs in your app until you run:

rake db:fix_orphan_line_items

We will print out a report of the data we are fixing now: "

    Spree::Greetingcard.only_deleted.each do |greetingcard|
      # determine if there is a slug duplicate
      the_dup = Spree::Greetingcard.find_by(slug: greetingcard.slug)
      if the_dup.nil?
        # check to see if there are line items attached to any variants
        if Spree::Variant.with_deleted.where(greetingcard_id: greetingcard.id).map(&:line_items).any?
          puts "recovering deleted greetingcard id #{greetingcard.id} ... this will un-delete the record and set it to be discontinued"

          old_deleted = greetingcard.deleted_at
          greetingcard.update_column(:deleted_at, nil) # for some reason .recover doesn't appear to be a method
          greetingcard.update_column(:discontinue_on, old_deleted)
        else
          puts "leaving greetingcard id #{greetingcard.id} deleted because there are no line items attached to it..."
        end
      else
        puts "leaving greetingcard id #{greetingcard.id} deleted because there is a duplicate slug for '#{greetingcard.slug}' (greetingcard id #{the_dup.id}) "
        if greetingcard.variants.map(&:line_items).any?
          puts "WARNING: You may still have bugs with greetingcard id #{greetingcard.id} (#{greetingcard.name}) until you run rake db:fix_orphan_line_items"
        end
      end
    end
  end

  def down
    execute "UPDATE `spree_greetingcards` SET `deleted_at` = `discontinue_on` WHERE `deleted_at` IS NULL"

    remove_column :spree_greetingcards, :discontinue_on
  end
end
