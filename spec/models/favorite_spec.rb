# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Favorite, type: :model do
  it 'belongs to a user and a polymorphic favorited record' do
    expect(described_class.reflect_on_association(:user).macro).to eq(:belongs_to)
    expect(described_class.reflect_on_association(:favorited).options[:polymorphic]).to be(true)
  end

  describe '.for_favorited_record' do
    it 'filters by the record class and id' do
      favorite_scope = described_class.for_favorited_record(Company.new(id: 12))

      expect(favorite_scope.where_values_hash).to include(
        'favorited_type' => 'Company',
        'favorited_id' => 12
      )
    end

    it 'supports records stored with a decorator type' do
      favorite_scope = described_class.for_favorited_record(Product.new(id: 34), favorited_type: 'ProductDecorator')

      expect(favorite_scope.where_values_hash).to include(
        'favorited_type' => 'ProductDecorator',
        'favorited_id' => 34
      )
    end
  end
end
