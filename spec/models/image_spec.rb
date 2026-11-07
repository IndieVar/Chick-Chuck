# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Image, type: :model do
  it 'requires an uploaded file' do
    image = described_class.new(imageable: Product.new)

    expect(image).not_to be_valid
    expect(image.errors[:file]).to be_present
  end

  it 'accepts an image file' do
    file = File.open(Rails.root.join('app/assets/images/seed/products/1.jpg'))
    image = described_class.new(imageable: Product.new)
    image.file = file

    expect(image).to be_valid
  ensure
    file&.close
  end
end
