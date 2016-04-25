module Spree
  module Admin
    module GreetingcardsHelper
      def taxon_options_for(greetingcard)
        options = @taxons.map do |taxon|
          selected = greetingcard.taxons.include?(taxon)
          content_tag(:option,
                      :value    => taxon.id,
                      :selected => ('selected' if selected)) do
            (taxon.ancestors.pluck(:name) + [taxon.name]).join(" -> ")
          end
        end
        safe_join(options)
      end

      def option_types_options_for(greetingcard)
        options = @option_types.map do |option_type|
          selected = greetingcard.option_types.include?(option_type)
          content_tag(:option,
                      :value    => option_type.id,
                      :selected => ('selected' if selected)) do
            option_type.name
          end
        end
        safe_join(options)
      end
    end
  end
end
