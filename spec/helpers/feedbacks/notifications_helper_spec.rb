# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Feedbacks::NotificationsHelper, type: :helper do
  around do |example|
    I18n.with_locale(:ru, &example)
  end

  it 'adds the current locale to a path without a locale prefix' do
    expect(helper.localized_notification_url('/carriers/12')).to eq('/ru/carriers/12')
  end

  it 'replaces an existing locale prefix without duplicating it' do
    expect(helper.localized_notification_url('/en/carriers/12')).to eq('/ru/carriers/12')
  end

  it 'preserves the host, query, and anchor of an absolute notification URL' do
    url = 'https://example.test/en/carriers/12?tab=reviews#review_4'

    expect(helper.localized_notification_url(url))
      .to eq('https://example.test/ru/carriers/12?tab=reviews#review_4')
  end

  it 'returns a blank URL unchanged' do
    expect(helper.localized_notification_url(nil)).to be_nil
  end
end
