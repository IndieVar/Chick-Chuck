# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client, type: :model do
  describe '#after_confirmation' do
    it 'creates a subscriber for the confirmed client' do
      client = described_class.new(email: 'confirmed-client@example.test')

      expect { client.after_confirmation }
        .to change(Subscriber, :count).by(1)
      expect(Subscriber.last.email).to eq(client.email)
    end

    it 'does not create a duplicate subscriber' do
      client = described_class.new(email: 'existing-subscriber@example.test')
      Subscriber.create!(email: client.email)

      expect { client.after_confirmation }.not_to change(Subscriber, :count)
    end
  end
end
