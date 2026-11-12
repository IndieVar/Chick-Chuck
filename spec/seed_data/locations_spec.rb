# frozen_string_literal: true

require 'spec_helper'
require_relative '../../db/seed_data/locations'

RSpec.describe LocationsSeedData do
  let(:cities) { described_class::DISTRICTS.flat_map { |district| district.fetch(:cities, []) } }

  it 'loads city, moshav, and kibbutz localities but excludes other CBS forms' do
    hebrew_names = cities.map { |city| city[:he] }

    expect(hebrew_names).to include('עכו', 'שחר', 'בית ניר')
    expect(hebrew_names).not_to include('באר אורה')
  end

  it 'provides all four locale names for every locality' do
    localized = cities.all? do |city|
      %i[ru en uk he].all? { |locale| !city.fetch(locale).to_s.empty? }
    end

    expect(localized).to be(true)
  end

  it 'provides all four locale names for localities without manual translations' do
    shahar = cities.find { |city| city[:he] == 'שחר' }

    expect(shahar).to eq(ru: 'Шахар', en: 'Shahar', uk: 'Шахар', he: 'שחר')
  end

  it 'parses quoted Hebrew locality names from the TSV' do
    locality = cities.find { |city| city[:he] == 'ניר ח"ן' }

    expect(locality).to include(ru: 'Нир Хен', en: 'Nir Hen', uk: 'Нир Хен', he: 'ניר ח"ן')
  end
end
