# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend
  require_relative 'image_helper'
  require_relative 'navigation_helper'
  require_relative 'meta_tags_helper'

  def device
    agent = request.user_agent
    return 'tablet' if agent =~ /(tablet|ipad)|(android(?!.*mobile))/i
    return 'mobile' if agent =~ /Mobile/

    'desktop'
  end

  def prepend_flash
    turbo_stream.prepend 'flash_messages', partial: 'shared/flash_messages'
  end

  def html_language_attributes
    language = response.header['Content-Language']
    tag.attributes(lang: language, dir: language == 'he' ? 'rtl' : 'ltr')
  end

  def phone_country_options
    Phonelib.phone_data.sort_by { |country, _| [country == Phonelib.default_country ? 0 : 1, country] }
            .map { |country, data| ["#{country} (+#{data[:country_code]})", country] }
  end
end
