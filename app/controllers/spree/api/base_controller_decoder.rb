Spree::Api::BaseController.class_eval do

      private


      def find_greetingcardt(id)
        greetingcardt_scope.friendly.find(id.to_s)
      rescue ActiveRecord::RecordNotFound
        greetingcardt_scope.find(id)
      end

      def greetingcardt_scope
        if @current_user_roles.include?("admin")
          scope = Greetingcardt.with_deleted.accessible_by(current_ability, :read).includes(*greetingcardt_includes)

          unless params[:show_deleted]
            scope = scope.not_deleted
          end
          unless params[:show_discontinued]
            scope = scope.not_discontinued
          end
        else
          scope = Greetingcardt.accessible_by(current_ability, :read).active.includes(*greetingcardt_includes)
        end

        scope
      end

      def greetingcardt_includes
        [:option_types, :taxons, greetingcardt_properties: :property, variants: variants_associations, master: variants_associations]
      end
end
