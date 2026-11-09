# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room, type: :model do
  it 'returns the room participant other than the given user' do
    sender = Client.create!(
      email: 'room-sender@example.test',
      password: 'valid-password',
      confirmed_at: Time.current
    )
    recipient = Client.create!(
      email: 'room-recipient@example.test',
      password: 'valid-password',
      confirmed_at: Time.current
    )
    room = described_class.create!(users: [sender, recipient])

    expect(room.recipient(sender)).to eq(recipient)
  end
end
