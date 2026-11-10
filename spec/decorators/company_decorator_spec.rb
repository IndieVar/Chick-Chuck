# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompanyDecorator do
  describe '#districts_for_display' do
    it 'shows only All Israel when that option is selected' do
      district = District.create!(ru: 'Округ', en: 'District', he: 'מחוז', uk: 'Округ')
      all_israel = District.create!(ru: 'Весь Израиль', en: 'All Israel', he: 'כל ישראל', uk: 'Увесь Ізраїль')
      company = Company.new(districts: [district, all_israel])
      displayed_districts = described_class.new(company).districts_for_display

      expect(displayed_districts.map(&:object)).to eq([all_israel])
    end

    it 'shows every associated district when All Israel is not selected' do
      district = District.create!(ru: 'Округ', en: 'District', he: 'מחוז', uk: 'Округ')
      second_district = District.create!(ru: 'Другой округ', en: 'Other District', he: 'מחוז אחר', uk: 'Інший округ')
      company = Company.new(districts: [district, second_district])
      displayed_districts = described_class.new(company).districts_for_display

      expect(displayed_districts.map(&:object)).to eq([district, second_district])
    end
  end

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
