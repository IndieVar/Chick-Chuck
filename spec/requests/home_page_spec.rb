# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homepage', type: :request do
  before do
    host! 'example.com'
  end

  it 'renders the redesigned homepage in every supported locale' do
    {
      en: 'Moving in Israel is easier than you think',
      he: 'מעבר דירה בישראל — פשוט יותר ממה שנדמה',
      ru: 'Переезд по Израилю — проще, чем кажется'
    }.each do |locale, title|
      get root_path(locale:)

      expect(response).to have_http_status(:ok), "homepage failed for #{locale}"
      expect(response.body).to include(title)
      expect(response.body).to include(I18n.t('pages.knowledge_base', locale:))
      expect(response.body).to include('Relomio')
    end
  end
end
