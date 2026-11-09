# frozen_string_literal: true

module Contents
  class CalculatorsController < ApplicationController
    include PricesHelper

    def show
      set_meta_tags(
        title: t('meta.calculator.title'),
        description: t('meta.calculator.desc'),
        noindex: request.original_url.include?('?') || false,
        alternate: {
          'x-default' => calculator_url(locale: nil),
          'en' => calculator_url(locale: :en),
          'ru' => calculator_url(locale: :ru),
          'uk' => calculator_url(locale: :uk)
        }
      )

      @categories = Category.all.decorate
      @companies = Company.confirmed
    end

    def company_calculator
      @company = Company.find_by_id(params[:company_id])
      @categories = Category.all.decorate

      set_meta_tags(
        title: [t('calculator.title'), @company.title],
        description: t('home_page.main_features.calculator_desc'),
        canonical: company_calculator_url(@company) # ,
        #         noindex: request.original_url.include?('?') ? true : false
      )
    end
  end
end
