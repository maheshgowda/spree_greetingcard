module Spree
  module GreetingcardsHelper
    # returns the formatted price for the specified variant as a full price or a difference depending on configuration
    def variant_price(variant)
      if Spree::Config[:show_variant_full_price]
        variant_full_price(variant)
      else
        variant_price_diff(variant)
      end
    end

    # returns the formatted price for the specified variant as a difference from greetingcard price
    def variant_price_diff(variant)
      variant_amount = variant.amount_in(current_currency)
      greetingcard_amount = variant.greetingcard.amount_in(current_currency)
      return if variant_amount == greetingcard_amount || greetingcard_amount.nil?
      diff   = variant.amount_in(current_currency) - greetingcard_amount
      amount = Spree::Money.new(diff.abs, currency: current_currency).to_html
      label  = diff > 0 ? :add : :subtract
      "(#{Spree.t(label)}: #{amount})".html_safe
    end

    # returns the formatted full price for the variant, if at least one variant price differs from greetingcard price
    def variant_full_price(variant)
      greetingcard = variant.greetingcard
      unless greetingcard.variants.active(current_currency).all? { |v| v.price == greetingcard.price }
        Spree::Money.new(variant.price, { currency: current_currency }).to_html
      end
    end

    # converts line breaks in greetingcard description into <p> tags (for html display purposes)
    def greetingcard_description(greetingcard)
      description = if Spree::Config[:show_raw_greetingcard_description]
                      greetingcard.description
                    else
                      greetingcard.description.to_s.gsub(/(.*?)\r?\n\r?\n/m, '<p>\1</p>')
                    end
      description.blank? ? Spree.t(:greetingcard_has_no_description) : raw(description)
    end

    def line_item_description_text description_text
      if description_text.present?
        truncate(strip_tags(description_text.gsub('&nbsp;', ' ').squish), length: 100)
      else
        Spree.t(:greetingcard_has_no_description)
      end
    end

    def cache_key_for_greetingcards
      count = @greetingcards.count
      max_updated_at = (@greetingcards.maximum(:updated_at) || Date.today).to_s(:number)
      greetingcards_cache_keys = "spree/greetingcards/all-#{params[:page]}-#{max_updated_at}-#{count}"
      (common_greetingcard_cache_keys + [greetingcards_cache_keys]).compact.join("/")
    end

    def cache_key_for_greetingcard(greetingcard = @greetingcard)
      (common_greetingcard_cache_keys + [greetingcard.cache_key, greetingcard.possible_promotions]).compact.join("/")
    end

    def available_status(greetingcard) # will return a human readable string
      return Spree.t(:discontinued)  if greetingcard.discontinued?
      return Spree.t(:deleted)  if greetingcard.deleted?

      if greetingcard.available?
        Spree.t(:available)
      elsif greetingcard.available_on && greetingcard.available_on.future?
        Spree.t(:pending_sale)
      else
        Spree.t(:no_available_date_set)
      end
    end

    private

    def common_greetingcard_cache_keys
      [I18n.locale, current_currency] + price_options_cache_key
    end

    def price_options_cache_key
      current_price_options.sort.map(&:last).map do |value|
        value.try(:cache_key) || value
      end
    end
  end
end