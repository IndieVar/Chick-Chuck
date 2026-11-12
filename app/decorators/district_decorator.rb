# frozen_string_literal: true

class DistrictDecorator < ApplicationDecorator
  delegate_all

  def title
    case I18n.locale
    when :ru then district.ru
    when :uk then district.uk
    when :en then district.en
    when :he then district.he
    end
  end

  def cities
    district.cities.decorate.sort_by { |city| city.title.to_s.downcase }
  end
end
