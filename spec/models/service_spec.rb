# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Service, type: :model do
  it 'requires a title in every supported language' do
    service = described_class.new(ru: 'Услуга', en: 'Service', he: 'שירות', uk: 'Послуга')

    expect(service).to be_valid
  end

  it 'rejects a missing translation' do
    service = described_class.new(ru: 'Услуга', en: 'Service', he: '', uk: 'Послуга')

    expect(service).not_to be_valid
    expect(service.errors[:he]).to be_present
  end
end
