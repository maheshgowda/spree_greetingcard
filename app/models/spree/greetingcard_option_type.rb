module Spree
  class GreetingcardOptionType < Spree::Base
    with_options inverse_of: :greetingcard_option_types do
      belongs_to :greetingcard, class_name: 'Spree::Greetingcard'
      belongs_to :option_type, class_name: 'Spree::OptionType'
    end
    acts_as_list scope: :greetingcard

    validates :greetingcard, :option_type, presence: true
    validates :greetingcard_id, uniqueness: { scope: :option_type_id }, allow_nil: true
  end
end
