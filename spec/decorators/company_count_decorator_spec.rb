# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompanyDecorator do
  it 'formats localized comment and review counts' do
    expected = {
      en: { 1 => '1 Comments', 2 => '2 Comments' },
      ru: { 1 => '1 Комментарий', 2 => '2 Комментария', 5 => '5 Комментариев' },
      uk: { 1 => '1 Коментар', 2 => '2 Коментара', 5 => '5 Коментарів' },
      he: { 1 => '1 הערה', 2 => '2 הערות' }
    }

    expected.each do |locale, counts|
      allow(I18n).to receive(:locale).and_return(locale)
      counts.each do |count, formatted|
        company = instance_double(Company, comments: double(count:), reviews: double(count:))
        expect(described_class.new(company).comments_count).to eq(formatted)
      end
    end

    allow(I18n).to receive(:locale).and_return(:ru)
    company = instance_double(Company, reviews: double(count: 2))
    expect(described_class.new(company).reviews_count).to eq('2 Отзыва')
  end
end
