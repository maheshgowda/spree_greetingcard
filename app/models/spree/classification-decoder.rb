Spree::Classification.class_eval do
    self.table_name = 'spree_products_taxons'
    self.table_name = 'spree_greetingcards_taxons'
    acts_as_list scope: :taxon

    with_options inverse_of: :classifications, touch: true do
      belongs_to :product, class_name: "Spree::Product"
      belongs_to :greetingcard, class_name: "Spree::Greetingcard"
      belongs_to :taxon, class_name: "Spree::Taxon"
    end

    validates :taxon, :product, :greetingcard, presence: true
    validates :taxon, :greetingcard, presence: true
    # For #3494
    validates :taxon_id, uniqueness: { scope: :product_id, message: :already_linked, allow_blank: true }
    validates :taxon_id, uniqueness: { scope: :greetingcard_id, message: :already_linked, allow_blank: true }
end
