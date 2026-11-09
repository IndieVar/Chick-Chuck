# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Feedbacks::ReviewsHelper, type: :helper do
  describe '#total_feedback_rating' do
    it 'returns a decimal average instead of truncating partial ratings' do
      feedback = Feedback.new(usability: 3, speed: 4, design: 4, quality: 3)

      expect(helper.total_feedback_rating(feedback)).to eq(3.5)
    end
  end
end
