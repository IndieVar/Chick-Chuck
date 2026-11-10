# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contents::NewsController, type: :controller do
  describe 'GET #index' do
    before do
      allow_any_instance_of(ActionDispatch::Request).to receive(:is_crawler?).and_return(false)
    end

    it 'renders successfully with localized news index URLs' do
      get :index, params: { locale: :ru }

      expect(response).to have_http_status(:ok)
    end
  end
end
