module Spree
  class GreetingcardsController < Spree::StoreController
    before_action :load_greetingcard, only: :show
    before_action :load_taxon, only: :index

    rescue_from ActiveRecord::RecordNotFound, :with => :render_404
    helper 'spree/taxons'

    respond_to :html

    def index
      @searcher = build_searcher(params.merge(include_images: true))
      @greetingcards = @searcher.retrieve_greetingcards.includes(:possible_promotions)
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end

    def show
      @variants = @greetingcard.variants_including_master.
                          spree_base_scopes.
                          active(current_currency).
                          includes([:option_values, :images])
      @greetingcard_properties = @greetingcard.greetingcard_properties.includes(:property)
      @taxon = params[:taxon_id].present? ? Spree::Taxon.find(params[:taxon_id]) : @greetingcard.taxons.first
      redirect_if_legacy_path
    end

    private

      def accurate_title
        if @greetingcard
          @greetingcard.meta_title.blank? ? @greetingcard.name : @greetingcard.meta_title
        else
          super
        end
      end

      def load_greetingcard
        if try_spree_current_user.try(:has_spree_role?, "admin")
          @greetingcards = Greetingcard.with_deleted
        else
          @greetingcards = Greetingcard.active(current_currency)
        end
        @greetingcard = @greetingcards.includes(:variants_including_master).friendly.find(params[:id])
      end

      def load_taxon
        @taxon = Spree::Taxon.find(params[:taxon]) if params[:taxon].present?
      end

      def redirect_if_legacy_path
        # If an old id or a numeric id was used to find the record,
        # we should do a 301 redirect that uses the current friendly id.
        if params[:id] != @greetingcard.friendly_id
          params.merge!(id: @greetingcard.friendly_id)
          return redirect_to url_for(params), status: :moved_permanently
        end
      end
  end
end