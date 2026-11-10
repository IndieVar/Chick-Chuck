# frozen_string_literal: true

require 'rails_helper'

RSpec.describe District do
  describe '.excluding_all_israel' do
    it 'returns districts except for the All Israel option' do
      district = District.create!(ru: 'Округ', en: 'District', he: 'מחוז', uk: 'Округ')
      all_israel = District.create!(ru: 'Весь Израиль', en: 'All Israel', he: 'כל ישראל', uk: 'Увесь Ізраїль')

      expect(described_class.excluding_all_israel).to contain_exactly(district)
      expect(described_class.excluding_all_israel).not_to include(all_israel)
    end
  end
end
