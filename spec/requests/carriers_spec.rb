# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Carrier directory', type: :request do
  before do
    host! 'example.com'
  end

  it 'renders when no carriers match the filters' do
    Company.delete_all

    get '/carriers'

    expect(response).to have_http_status(:ok)
  end
end
