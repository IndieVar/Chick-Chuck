# frozen_string_literal: true

class CompanyDecorator < ApplicationDecorator
  include LocalizedCount

  def created_at
    "#{User.human_attribute_name('created_at')}: #{l company.created_at, format: :date}"
  end

  def districts_for_display
    districts = company.districts.to_a
    all_israel = districts.find { |district| district.en == 'All Israel' }
    districts = [all_israel] if all_israel

    DistrictDecorator.decorate_collection(districts)
  end

  def review_star_percent_count(rating)
    review_percent_count(:rating, rating)
  end

  def review_price_percent_count(price)
    review_percent_count(:price, price)
  end

  def comments_count
    localized_count(company.comments.count, :comments)
  end

  def reviews_count
    localized_count(company.reviews.count, :reviews)
  end

  private

  def review_percent_count(attribute, value)
    counts = review_counts(attribute)
    total = counts.values.sum
    return 0 if total.zero?

    (counts.fetch(value, 0).to_f / total * 100).round(1)
  end

  def review_counts(attribute)
    @review_counts ||= {}
    @review_counts[attribute] ||= company.reviews.group(attribute).count
  end
end
