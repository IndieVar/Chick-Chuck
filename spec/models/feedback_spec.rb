# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Feedback, type: :model do
  it 'accepts rating values from zero through five' do
    feedback = described_class.new(
      user: Client.new,
      usability: 0,
      speed: 5,
      design: 3,
      quality: 4,
      informative: false,
      problems: false
    )

    expect(feedback).to be_valid
  end

  it 'rejects ratings above five' do
    feedback = described_class.new(
      user: Client.new,
      usability: 6,
      speed: 3,
      design: 3,
      quality: 3,
      informative: false,
      problems: false
    )

    expect(feedback).not_to be_valid
    expect(feedback.errors[:usability]).to be_present
  end
end
