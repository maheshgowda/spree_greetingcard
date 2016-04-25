Spree::Property.class_eval do
    has_many :property_prototypes, class_name: 'Spree::PropertyPrototype'
    has_many :prototypes, through: :property_prototypes, class_name: 'Spree::Prototype'

    has_many :product_properties, dependent: :delete_all, inverse_of: :property
    has_many :products, through: :product_properties
    
    has_many :greetingcard_properties, dependent: :delete_all, inverse_of: :property
    has_many :greetingcards, through: :greetingcard_properties

    validates :name, :presentation, presence: true

    scope :sorted, -> { order(:name) }

    after_touch :touch_all_products
    after_touch :touch_all_greetingcards

    self.whitelisted_ransackable_attributes = ['presentation']

    private

    def touch_all_products
      products.update_all(updated_at: Time.current)
    end
    
    def touch_all_greetingcards
      greetingcards.update_all(updated_at: Time.current)
    end
end
