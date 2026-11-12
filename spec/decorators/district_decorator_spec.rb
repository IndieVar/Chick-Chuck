# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DistrictDecorator do
  let(:district) do
    District.new(ru: 'Округ', en: 'District', he: 'מחוז', uk: 'Округ').tap do |record|
      record.cities.build(ru: 'Яффо', en: 'Zion', he: 'יפו', uk: 'Яффо')
      record.cities.build(ru: 'Акко', en: 'Akko', he: 'עכו', uk: 'Акко')
    end
  end

  it 'sorts cities by their localized display title' do
    english_cities = I18n.with_locale(:en) { described_class.new(district).cities.map(&:en) }
    russian_cities = I18n.with_locale(:ru) { described_class.new(district).cities.map(&:ru) }

    expect(english_cities).to eq(%w[Akko Zion])
    expect(russian_cities).to eq(%w[Акко Яффо])
  end
end
