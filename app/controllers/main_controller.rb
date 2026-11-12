# frozen_string_literal: true

class MainController < ApplicationController
  def index
    set_meta_tags(homepage_meta_tags)
    load_homepage_content
  end

  def sitemap
    @locales   = I18n.available_locales
    @users     = Company.confirmed
    @districts = District.ids
    @languages = Language.ids
    @services  = Service.ids
    @products  = Product.published
  end

  def robots; end

  def favicon
    respond_to do |format|
      format.png do
        send_file 'app/assets/images/favicon.png', type: 'image/png', disposition: 'inline', sizes: '120x120'
      end
    end
  end

  def cookies
    respond_to do |format|
      format.turbo_stream do
        session[:cookies_accepted] = params[:cookies].presence
      end
    end
  end

  private

  def homepage_meta_tags
    {
      title: [params[:locale]&.capitalize, t('meta.home_page.title')],
      description: t('meta.home_page.desc'),
      alternate: {
        'x-default' => root_url(locale: nil),
        'en' => root_url(locale: :en),
        'ru' => root_url(locale: :ru),
        'uk' => root_url(locale: :uk)
      }
    }
  end

  def load_homepage_content
    load_carrier_summary
    load_market_summary
    @news = News.all.decorate.last(3)
  end

  def load_carrier_summary
    companies = Company.confirmed
    @companies = companies.with_directory_details.take(3)
    @companies_count = companies.count
    @average_rating = companies.where('rating > 0').average(:rating)&.round(1)
  end

  def load_market_summary
    products = Product.published
    @products_count = products.count
    @products = products.decorate.take(4)
  end
end
