# frozen_string_literal: true

module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filtering_params)
      apply_filters(where(published: true), filtering_params)
    end

    def user_filter(filtering_params)
      apply_filters(where.not(type: 'Admin'), filtering_params)
    end

    def user_products_filter(user, filtering_params)
      apply_filters(where(user_id: user, published: true), filtering_params)
    end

    private

    def apply_filters(results, filtering_params)
      filtering_params.each do |key, value|
        results = results.public_send("filter_by_#{key}", value) if value.present?
      end
      results
    end
  end
end
