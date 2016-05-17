class AddGreetingcardPictureToSpreeGreetingcards < ActiveRecord::Migration
  def change
    add_attachment :spree_greetingcards, :greetingcard_picture
  end
end
