module Spree
  module Api
    module V1
      class GreetingcardsController < Spree::Api::BaseController

        def index
          if params[:ids]
            @greetingcards = greetingcard_scope.where(id: params[:ids].split(",").flatten)
          else
            @greetingcards = greetingcard_scope.ransack(params[:q]).result
          end

          @greetingcards = @greetingcards.distinct.page(params[:page]).per(params[:per_page])
          expires_in 15.minutes, :public => true
          headers['Surrogate-Control'] = "max-age=#{15.minutes}"
          respond_with(@greetingcards)
        end

        def show
          @greetingcard = find_greetingcard(params[:id])
          expires_in 15.minutes, :public => true
          headers['Surrogate-Control'] = "max-age=#{15.minutes}"
          headers['Surrogate-Key'] = "greetingcard_id=1"
          respond_with(@greetingcard)
        end

        # Takes besides the greetingcards attributes either an array of variants or
        # an array of option types.
        #
        # By submitting an array of variants the option types will be created
        # using the *name* key in options hash. e.g
        #
        #   greetingcard: {
        #     ...
        #     variants: {
        #       price: 19.99,
        #       sku: "hey_you",
        #       options: [
        #         { name: "size", value: "small" },
        #         { name: "color", value: "black" }
        #       ]
        #     }
        #   }
        #
        # Or just pass in the option types hash:
        #
        #   greetingcard: {
        #     ...
        #     option_types: ['size', 'color']
        #   }
        #
        # By passing the shipping category name you can fetch or create that
        # shipping category on the fly. e.g.
        #
        #   greetingcard: {
        #     ...
        #     shipping_category: "Free Shipping Items"
        #   }
        #
        def create
          authorize! :create, Greetingcard
          params[:greetingcard][:available_on] ||= Time.current
          set_up_shipping_category

          options = { variants_attrs: variants_params, options_attrs: option_types_params }
          @greetingcard = Core::Importer::Greetingcard.new(nil, greetingcard_params, options).create

          if @greetingcard.persisted?
            respond_with(@greetingcard, :status => 201, :default_template => :show)
          else
            invalid_resource!(@greetingcard)
          end
        end

        def update
          @greetingcard = find_greetingcard(params[:id])
          authorize! :update, @greetingcard

          options = { variants_attrs: variants_params, options_attrs: option_types_params }
          @greetingcard = Core::Importer::Greetingcard.new(@greetingcard, greetingcard_params, options).update

          if @greetingcard.errors.empty?
            respond_with(@greetingcard.reload, :status => 200, :default_template => :show)
          else
            invalid_resource!(@greetingcard)
          end
        end

        def destroy
          @greetingcard = find_greetingcard(params[:id])
          authorize! :destroy, @greetingcard
          @greetingcard.destroy
          respond_with(@greetingcard, :status => 204)
        end

        private
          def greetingcard_params
            params.require(:greetingcard).permit(permitted_greetingcard_attributes)
          end

          def variants_params
            variants_key = if params[:greetingcard].has_key? :variants
              :variants
            else
              :variants_attributes
            end

            params.require(:greetingcard).permit(
              variants_key => [permitted_variant_attributes, :id],
            ).delete(variants_key) || []
          end

          def option_types_params
            params[:greetingcard].fetch(:option_types, [])
          end

          def set_up_shipping_category
            if shipping_category = params[:greetingcard].delete(:shipping_category)
              id = ShippingCategory.find_or_create_by(name: shipping_category).id
              params[:greetingcard][:shipping_category_id] = id
            end
          end
      end
    end
  end
end
