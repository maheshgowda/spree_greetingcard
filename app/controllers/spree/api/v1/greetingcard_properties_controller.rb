module Spree
  module Api
    module V1
      class GreetingcardPropertiesController < Spree::Api::BaseController
        before_action :find_greetingcard
        before_action :greetingcard_property, only: [:show, :update, :destroy]

        def index
          @greetingcard_properties = @greetingcard.greetingcard_properties.accessible_by(current_ability, :read).
                                ransack(params[:q]).result.
                                page(params[:page]).per(params[:per_page])
          respond_with(@greetingcard_properties)
        end

        def show
          respond_with(@greetingcard_property)
        end

        def new
        end

        def create
          authorize! :create, GreetingcardProperty
          @greetingcard_property = @greetingcard.greetingcard_properties.new(greetingcard_property_params)
          if @greetingcard_property.save
            respond_with(@greetingcard_property, status: 201, default_template: :show)
          else
            invalid_resource!(@greetingcard_property)
          end
        end

        def update
          if @greetingcard_property
            authorize! :update, @greetingcard_property
            @greetingcard_property.update_attributes(greetingcard_property_params)
            respond_with(@greetingcard_property, status: 200, default_template: :show)
          else
            invalid_resource!(@greetingcard_property)
          end
        end

        def destroy
          if @greetingcard_property
            authorize! :destroy, @greetingcard_property
            @greetingcard_property.destroy
            respond_with(@greetingcard_property, status: 204)
          else
            invalid_resource!(@greetingcard_property)
          end
        end

        private

        def find_greetingcard
          @greetingcard = super(params[:greetingcard_id])
          authorize! :read, @greetingcard
        end

        def greetingcard_property
          if @greetingcard
            @greetingcard_property ||= @greetingcard.greetingcard_properties.find_by(id: params[:id])
            @greetingcard_property ||= @greetingcard.greetingcard_properties.includes(:property).where(spree_properties: { name: params[:id] }).first
            authorize! :read, @greetingcard_property
          end
        end

        def greetingcard_property_params
          params.require(:greetingcard_property).permit(permitted_greetingcard_properties_attributes)
        end
      end
    end
  end
end
