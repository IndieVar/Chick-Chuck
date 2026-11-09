# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room, type: :model do
  it 'filters rooms by an exact case-insensitive participant display name' do
    sender, matching_user, other_user = %w[current demo demolition].map do |first_name|
      Client.create!(
        email: "room-search-#{first_name}@example.test",
        password: 'valid-password',
        first_name:,
        last_name: 'Carrier',
        confirmed_at: Time.current
      )
    end
    matching_room = described_class.create!(users: [sender, matching_user])
    described_class.create!(users: [sender, other_user])

    expect(described_class.with_user_named('dEmO cArRiEr')).to contain_exactly(matching_room)
  end
end
