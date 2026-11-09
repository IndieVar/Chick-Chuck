# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  it 'delegates recipient lookup to its room' do
    sender = Client.new(id: 1)
    recipient = Client.new(id: 2)
    room = Room.new
    message = described_class.new(user: sender, room:)

    expect(room).to receive(:recipient).with(sender).and_return(recipient)

    expect(message.recipient).to eq(recipient)
  end
end
