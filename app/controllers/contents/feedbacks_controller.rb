# frozen_string_literal: true

module Contents
  class FeedbacksController < ApplicationController
    before_action :authenticate_user!, except: :index
    before_action :set_feedback

    def index
      set_meta_tags(
        title: t('meta.feedbacks.title'),
        description: t('meta.feedbacks.desc'),
        alternate: {
          'x-default' => feedbacks_url(locale: nil),
          'en' => feedbacks_url(locale: :en),
          'ru' => feedbacks_url(locale: :ru),
          'uk' => feedbacks_url(locale: :uk)
        }
      )

      @feedback ||= Feedback.new
      feedbacks = Feedback.all

      @global_feedback = {
        usability: (feedbacks.average(:usability) || 0).to_f,
        speed: (feedbacks.average(:speed) || 0).to_f,
        design: (feedbacks.average(:design) || 0).to_f,
        quality: (feedbacks.average(:quality) || 0).to_f
      }

      @total_rating = (@global_feedback.values.sum / 4.0).round(1)

      @reviews = Feedback.where.not(content: [nil, '']).where.not(title: [nil, ''])
    end

    def create
      @feedback = Feedback.new(feedback_params)
      @feedback.user_id = current_user.id

      respond_to do |format|
        if @feedback.save
          format.html do
            redirect_to feedbacks_path, success: t('flash.success.created', model: @feedback.model_name.human.to_s)
          end
        else
          format.html { redirect_to feedbacks_path, alert: t('flash.alert') }
        end
      end
    end

    def edit; end

    def update
      respond_to do |format|
        if @feedback.update(feedback_params)
          format.html do
            redirect_to feedbacks_path, success: t('flash.success.updated', model: @feedback.model_name.human.to_s)
          end
        else
          format.html { redirect_to feedbacks_path, alert: t('flash.alert') }
        end
      end
    end

    private

    def feedback_params
      params.require(:feedback).permit(:usability, :speed, :design, :quality, :informative, :problems, :title, :content)
    end

    def set_feedback
      @feedback = Feedback.find_by(user_id: current_user.id) if client_signed_in? || company_signed_in?
    end
  end
end
