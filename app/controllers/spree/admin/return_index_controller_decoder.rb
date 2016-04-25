Spree::Admin::ReturnIndexController.class_eval do
      

      private

      def collection(resource)
        return @collection if @collection.present?
        params[:q] ||= {}

        @collection = resource.all
        # @search needs to be defined as this is passed to search_form_for
        @search = @collection.ransack(params[:q])
        per_page = params[:per_page] || Spree::Config[:admin_products_per_page]
        per_page = params[:per_page] || Spree::Config[:admin_greetingcards_per_page]
        @collection = @search.result.order(created_at: :desc).page(params[:page]).per(per_page)
      end
end
