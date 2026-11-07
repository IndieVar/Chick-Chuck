# frozen_string_literal: true

module Users
  class UsersController < ApplicationController
    include Feedbacks::ReviewsHelper
    include PricesHelper
    before_action :set_user, only: %i[show modal contacts]
    after_action  :update_views, only: :show

    def index
      set_meta_tags(
        title: t('meta.carriers.title'),
        description: t('meta.carriers.desc'),
        keywords: Service.all.decorate.map(&:title).join(', ').sub(/(, )+$/, ''),
        noindex: request.original_url.include?('?') ? true : false,
        alternate: {
          'x-default' => users_url(locale: nil),
          'en' => users_url(locale: :en),
          'ru' => users_url(locale: :ru),
          'uk' => users_url(locale: :uk)
        }
      )

      companies = Company.confirmed.user_filter(filter_params)
      @best_companies = companies.take(3)
      latest_companies = companies.drop(3)
      @companies_count = latest_companies.count
      @pagy_a, @latest_companies = pagy_array(latest_companies, items: 8)
    end

    def show
      set_meta_tags(
        title: [t('israel'), @user.user_name.capitalize],
        keywords: @user.services.decorate.map(&:title).join(', ').sub(/(, )+$/, ''),
        description: @user.instance_of?(Company) && @user.description.present? ? @user.description.to_s : "#{@user.user_name.capitalize} | #{t('company.carriers').capitalize} | #{t('home_page.main_features.reviews_desc')}",
        og: {
          image: @user.avatar.url
        }
      )

      return redirect_to root_path unless @user.instance_of?(Company)

      @commentable = @user
      @comment = Comment.new
      @reviewable = @user
      @review = current_client&.company_review(@reviewable) || Review.new
      @reviews = @user.reviews.where.not(content: [nil, '']).where.not(title: [nil, ''])
      @reviews_count = @reviews.count
      @pagy, @reviews = pagy(@reviews, items: 10, fragment: '#reviews')
    end

    def modal
      set_meta_tags(
        title: [t('user_menu.profile'), @user.user_name.capitalize],
        description: "#{@user.user_name.capitalize} | #{t('user_menu.profile')}",
        noindex: true
      )
    end

    def contacts
      set_meta_tags(
        title: [t('contacts'), @user.user_name.capitalize],
        description: "#{@user.user_name.capitalize} | #{t('contacts')} | #{t('contacts_desc_html')}"
      )
      # return redirect_to new_client_session_path, alert: t('devise.failure.unauthenticated') unless user_signed_in?
    end

    private

    def filter_params
      params.permit(:district_id, :language_id, { service_ids: [] })
    end

    def set_user
      @user = User.find(params[:user_id] || params[:id])
    end

    def update_views
      return if request.is_crawler? || current_admin || current_company == @user

      @user.update(views: @user.views + 1)
    end
  end
end
