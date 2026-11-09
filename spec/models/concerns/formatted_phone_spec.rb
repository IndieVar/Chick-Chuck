# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FormattedPhone, type: :model do
  subject(:client) do
    Client.new(
      phone: '+12025550123',
      additional_phone: '+12025550124',
      whatsapp: '+12025550125'
    )
  end

  it 'formats each phone number consistently without dropping unchanged strings' do
    expect(client.formatted_phone).to eq('(202) 555-0123')
    expect(client.formatted_additional_phone).to eq('(202) 555-0124')
    expect(client.formatted_whatsapp).to eq('(202) 555-0125')
  end

  it 'returns the original value when a phone number cannot be parsed' do
    client.phone = 'not-a-phone-number'

    expect(client.formatted_phone).to eq('not-a-phone-number')
  end
end
