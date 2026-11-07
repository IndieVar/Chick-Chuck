# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Favorite, type: :model do
  it 'belongs to a user and a polymorphic favorited record' do
    expect(described_class.reflect_on_association(:user).macro).to eq(:belongs_to)
    expect(described_class.reflect_on_association(:favorited).options[:polymorphic]).to be(true)
  end
end
