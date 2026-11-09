# frozen_string_literal: true

module Feedbacks
  class ReviewsController < ApplicationController
    include ReviewsHelper
    before_action :authenticate_client!
    before_action :set_reviewable
    before_action :set_review, only: %i[edit update]
    before_action :limit_review, only: %i[new create]

    def new
      @review = Review.new
    end

    def create
      @review = @reviewable.reviews.build(review_params.except(:company_id))
      @review.user_id = current_client.id if client_signed_in?

      respond_to do |format|
        if @review.save
          @reviewable.refresh_ratings
          format.turbo_stream { flash.now[:success] = t('flash.success.created', model: @review.model_name.human.to_s) }
        else
          format.html { redirect_to @reviewable, alert: t('flash.alert') }
        end
      end
    end

    def edit; end

    def update
      respond_to do |format|
        if @review.update(review_params.except(:company_id))
          @reviewable.refresh_ratings
          format.turbo_stream { flash.now[:success] = t('flash.success.updated', model: @review.model_name.human.to_s) }
        else
          format.html { redirect_to @reviewable, alert: t('flash.alert') }
        end
      end
    end

    private

    def review_params
      params.require(:review).permit(:company_id, :rating, :price, :title, :content)
    end

    def set_reviewable
      @reviewable = Company.find_by_id(params[:company_id]) || Company.find_by_id(review_params[:company_id])
    end

    def set_review
      @review = Review.find_by_id(params[:id])
    end
  end
end
