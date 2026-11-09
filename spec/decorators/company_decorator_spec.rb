# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompanyDecorator do
  describe '#review_star_percent_count' do
    it 'calculates percentages with one grouped query per decorator' do
      grouped_reviews = double
      reviews = double
      company = instance_double(Company, reviews:)
      decorator = described_class.new(company)

      expect(reviews).to receive(:group).with(:rating).once.and_return(grouped_reviews)
      expect(grouped_reviews).to receive(:count).once.and_return(5 => 2, 4 => 1)

      expect(decorator.review_star_percent_count(5)).to eq(66.7)
      expect(decorator.review_star_percent_count(4)).to eq(33.3)
      expect(decorator.review_star_percent_count(3)).to eq(0)
    end

    it 'returns zero when there are no reviews' do
      reviews = double
      company = instance_double(Company, reviews:)
      decorator = described_class.new(company)

      allow(reviews).to receive(:group).with(:rating).and_return(reviews)
      allow(reviews).to receive(:count).and_return({})

      expect(decorator.review_star_percent_count(5)).to eq(0)
    end
  end
end
