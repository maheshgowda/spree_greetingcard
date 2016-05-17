module Spree
  module Core
    module Importer
      class Greetingcard
        attr_reader :greetingcard, :greetingcard_attrs, :variants_attrs, :options_attrs

        def initialize(greetingcard, greetingcard_params, options = {})
          @greetingcard = greetingcard || Spree::Greetingcard.new(greetingcard_params)

          @greetingcard_attrs = greetingcard_params
          @variants_attrs = options[:variants_attrs] || []
          @options_attrs = options[:options_attrs] || []
        end

        def create
          if greetingcard.save
            variants_attrs.each do |variant_attribute|
              # make sure the greetingcard is assigned before the options=
              greetingcard.variants.create({ greetingcard: greetingcard }.merge(variant_attribute))
            end

            set_up_options
          end

          greetingcard
        end

        def update
          if greetingcard.update_attributes(greetingcard_attrs)
            variants_attrs.each do |variant_attribute|
              # update the variant if the id is present in the payload
              if variant_attribute['id'].present?
                greetingcard.variants.find(variant_attribute['id'].to_i).update_attributes(variant_attribute)
              else
                # make sure the greetingcard is assigned before the options=
                greetingcard.variants.create({ greetingcard: greetingcard }.merge(variant_attribute))
              end
            end

            set_up_options
          end

          greetingcard
        end

        private
          def set_up_options
            options_attrs.each do |name|
              option_type = Spree::OptionType.where(name: name).first_or_initialize do |option_type|
                option_type.presentation = name
                option_type.save!
              end

              unless greetingcard.option_types.include?(option_type)
                greetingcard.option_types << option_type
              end
            end
          end
      end
    end
  end
end
