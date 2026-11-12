# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#html_language_attributes' do
    it 'sets Hebrew to right-to-left' do
      allow(helper.response).to receive(:header).and_return('Content-Language' => 'he')

      expect(helper.html_language_attributes).to eq('lang="he" dir="rtl"')
    end

    it 'sets other languages to left-to-right' do
      allow(helper.response).to receive(:header).and_return('Content-Language' => 'ru')

      expect(helper.html_language_attributes).to eq('lang="ru" dir="ltr"')
    end
  end

  describe '#sort_alphabetically' do
    it 'sorts records case-insensitively by their displayed title' do
      zulu = Struct.new(:title).new('Zulu')
      alpha = Struct.new(:title).new('alpha')

      expect(helper.sort_alphabetically([zulu, alpha])).to eq([alpha, zulu])
    end
  end
end
