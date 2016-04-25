module Spree
  class GreetingcardPromotionRule < Spree::Base
    belongs_to :greetingcard, class_name: 'Spree::Greetingcard'
    belongs_to :promotion_rule, class_name: 'Spree::PromotionRule'

    validates :greetingcard, :promotion_rule, presence: true
    validates :greetingcard_id, uniqueness: { scope: :promotion_rule_id }, allow_nil: true
  end
end