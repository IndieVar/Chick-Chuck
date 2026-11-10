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

  it 'normalizes a formatted local WhatsApp number to Israeli E.164 format' do
    client.email = 'israeli-whatsapp@example.test'
    client.password = 'valid-password'
    client.whatsapp = '(050) 234-5678'

    expect { client.save! }.to change(client, :whatsapp).to('+972502345678')
  end

  it 'uses the selected region for local WhatsApp numbers' do
    client.email = 'international-whatsapp@example.test'
    client.password = 'valid-password'
    client.whatsapp = '(202) 555-0123'
    client.whatsapp_country = 'US'

    expect { client.save! }.to change(client, :whatsapp).to('+12025550123')
  end

  it 'normalizes credential and contact phone numbers using their selected regions' do
    client.email = 'regional-phone@example.test'
    client.password = 'valid-password'
    client.phone = '(202) 555-0123'
    client.phone_country = 'US'
    client.additional_phone = '(050) 234-5678'
    client.additional_phone_country = 'IL'

    expect(client).to be_valid
    expect(client.phone).to eq('+12025550123')
    expect(client.additional_phone).to eq('+972502345678')
  end

  it 'rejects invalid numbers for the selected region' do
    client.phone = 'not a phone'
    client.phone_country = 'US'

    expect(client).not_to be_valid
    expect(client.errors[:phone]).to be_present
  end
end
