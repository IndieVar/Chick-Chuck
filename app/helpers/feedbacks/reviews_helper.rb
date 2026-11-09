# frozen_string_literal: true

module Feedbacks
  module ReviewsHelper
    REVIEW_ACTION_LINK_CLASS = %w[
      text-white bg-gradient-to-r from-blue-500 via-blue-600 to-blue-700 hover:bg-gradient-to-br
      focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5
      text-center h-10 flex items-center
    ].join(' ').freeze

    protected

    def limit_review
      user_review = current_client.company_review(@reviewable) if client_signed_in?

      redirect_to edit_review_path(@reviewable, user_review) if user_review.present?
    end

    def create_or_update_review(company)
      user_review = current_client.company_review(company) if client_signed_in?

      if user_review.present?
        link_to(t('review.edit'), edit_review_path(user_review, company_id: company.id),
                class: REVIEW_ACTION_LINK_CLASS,
                data: { turbo_frame: 'modal' })
      else
        link_to(t('review.add'), client_signed_in? ? new_review_path(company_id: company.id) : new_client_session_path,
                class: REVIEW_ACTION_LINK_CLASS,
                data: { turbo_frame: 'modal' })
      end
    end

    def total_feedback_rating(feedback)
      rating = (feedback.usability + feedback.speed + feedback.design + feedback.quality) / 4.0
      rating.round(1)
    end

    def review_star_color(rating, index)
      (0..rating).include?(index) ? 'text-yellow-400' : 'text-gray-400'
    end

    def review_price_color(price, index)
      case price
      when 0..3
        (0..price).include?(index) ? 'text-green-600' : 'text-gray-400'
      when 3..4
        (0..price).include?(index) ? 'text-yellow-400' : 'text-gray-400'
      when 4..5
        (0..price).include?(index) ? 'text-red-400' : 'text-gray-400'
      end
    end

    def review_hover_price_color(index)
      case index
      when 0..3
        'hover:text-green-600'
      when 3..4
        'hover:text-yellow-400'
      when 4..5
        'hover:text-red-400'
      else
        'text-gray-400'
      end
    end

    def total_price_rating_color(price)
      case price
      when 0.1..3
        'text-green-600'
      when 3..4
        'text-yellow-400'
      when 4..5
        'text-red-400'
      else
        'text-gray-400'
      end
    end

    def total_star_rating_color(rating)
      if rating >= 4.9
        'text-green-500'
      else
        rating >= 4 ? 'text-yellow-400' : 'text-gray-400'
      end
    end
  end
end
