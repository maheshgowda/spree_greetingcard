# A rule to limit a promotion based on greetingcards in the order.
# Can require all or any of the greetingcards to be present.
# Valid greetingcards either come from assigned greetingcard group or are assingned directly to the rule.
module Spree
  class Promotion
    module Rules
      class Greetingcard < PromotionRule
        has_many :greetingcard_promotion_rules, class_name: 'Spree::GreetingcardPromotionRule',
                                           foreign_key: :promotion_rule_id
        has_many :greetingcards, through: :greetingcard_promotion_rules, class_name: 'Spree::Greetingcard'

        MATCH_POLICIES = %w(any all none)
        preference :match_policy, :string, default: MATCH_POLICIES.first

        # scope/association that is used to test eligibility
        def eligible_greetingcards
          greetingcards
        end

        def applicable?(promotable)
          promotable.is_a?(Spree::Order)
        end

        def eligible?(order, options = {})
          return true if eligible_greetingcards.empty?

          if preferred_match_policy == 'all'
            unless eligible_greetingcards.all? {|p| order.greetingcards.include?(p) }
              eligibility_errors.add(:base, eligibility_error_message(:missing_greetingcard))
            end
          elsif preferred_match_policy == 'any'
            unless order.greetingcards.any? {|p| eligible_greetingcards.include?(p) }
              eligibility_errors.add(:base, eligibility_error_message(:no_applicable_greetingcards))
            end
          else
            unless order.greetingcards.none? {|p| eligible_greetingcards.include?(p) }
              eligibility_errors.add(:base, eligibility_error_message(:has_excluded_greetingcard))
            end
          end

          eligibility_errors.empty?
        end

        def actionable?(line_item)
          case preferred_match_policy
          when 'any', 'all'
            greetingcard_ids.include? line_item.variant.greetingcard_id
          when 'none'
            greetingcard_ids.exclude? line_item.variant.greetingcard_id
          else
            raise "unexpected match policy: #{preferred_match_policy.inspect}"
          end
        end

        def greetingcard_ids_string
          greetingcard_ids.join(',')
        end

        def greetingcard_ids_string=(s)
          self.greetingcard_ids = s.to_s.split(',').map(&:strip)
        end
      end
    end
  end
end
