# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client, type: :model do
  let(:auth_info) { double(name: 'Demo Carrier', email: 'oauth-client@example.test') }
  let(:auth) { double(provider: 'google_oauth2', uid: 'provider-user-123', info: auth_info) }

  it 'returns the account created by a concurrent OAuth request' do
    existing_client = instance_double(Client)
    record = Client.new
    record.errors.add(:email, :taken)
    allow(described_class).to receive(:find_or_create_by!)
      .with(email: auth_info.email)
      .and_raise(ActiveRecord::RecordInvalid.new(record))
    allow(described_class).to receive(:find_by).with(email: auth_info.email).and_return(existing_client)

    expect(described_class.from_omniauth(auth)).to eq(existing_client)
  end
end

RSpec.describe Client, type: :model do
  let(:auth_info) { double(name: 'Demo Carrier', email: 'oauth-client@example.test') }
  let(:auth) { double(provider: 'google_oauth2', uid: 'provider-user-123', info: auth_info) }

  it 'returns an existing client with the provider email without overwriting profile data' do
    existing_client = Client.create!(
      email: auth_info.email,
      password: 'valid-password',
      first_name: 'Existing',
      last_name: 'Account',
      provider: 'facebook',
      confirmed_at: Time.current
    )

    client = described_class.from_omniauth(auth)

    expect(client).to eq(existing_client)
    expect(client).to have_attributes(
      first_name: 'Existing',
      last_name: 'Account',
      provider: 'facebook'
    )
  end
end

RSpec.describe Client, type: :model do
  let(:auth_info) { double(name: 'Demo Carrier', email: 'oauth-client@example.test') }
  let(:auth) { double(provider: 'google_oauth2', uid: 'provider-user-123', info: auth_info) }

  it 'creates a confirmed client with the provider identity and name' do
    allow(Devise).to receive(:friendly_token).and_return('generated-password-token')

    client = described_class.from_omniauth(auth)

    expect(client).to be_persisted
    expect(client).to be_confirmed
    expect(client).to have_attributes(
      provider: 'google_oauth2',
      uid: 'provider-user-123',
      email: auth_info.email,
      first_name: 'Demo',
      last_name: 'Carrier'
    )
  end
end

RSpec.describe Client, type: :model do
  let(:auth_info) { double(name: 'Demo', email: 'oauth-client@example.test') }
  let(:auth) { double(provider: 'google_oauth2', uid: 'provider-user-123', info: auth_info) }

  it 'keeps a one-word provider name in both name fields' do
    allow(Devise).to receive(:friendly_token).and_return('generated-password-token')

    client = described_class.from_omniauth(auth)

    expect(client).to have_attributes(first_name: 'Demo', last_name: 'Demo')
  end
end
