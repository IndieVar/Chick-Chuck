# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client, type: :model do
  describe '#company_review' do
    it 'looks up the client review through the company association' do
      client = described_class.new(id: 12)
      reviews = double
      company = instance_double(Company, reviews:)
      review = instance_double(Review)

      expect(reviews).to receive(:find_by).with(user_id: 12).and_return(review)

      expect(client.company_review(company)).to eq(review)
    end
  end
end
