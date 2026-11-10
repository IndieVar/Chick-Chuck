# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewsDecorator do
  it 'counts comments once and uses the shared localized formatter' do
    comments = double
    news = instance_double(News, comments:)
    allow(I18n).to receive(:locale).and_return(:ru)

    expect(comments).to receive(:count).once.and_return(5)
    expect(described_class.new(news).comments_count).to eq('5 Комментариев')
  end
end
