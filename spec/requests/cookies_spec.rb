# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cookie consent', type: :request do
  before do
    host! 'example.com'
  end

  it 'saves acceptance in the session and hides the banner on later requests' do
    post '/cookies',
         params: { cookies: true },
         headers: { 'HTTP_ACCEPT' => 'text/vnd.turbo-stream.html', 'HTTP_USER_AGENT' => 'Mozilla/5.0' }

    expect(response).to have_http_status(:ok)
    expect(response.media_type).to eq('text/vnd.turbo-stream.html')
    expect(response.body).to include('remove')

    get '/carriers', headers: { 'HTTP_USER_AGENT' => 'Mozilla/5.0' }

    expect(response).to have_http_status(:ok)
    expect(response.body).not_to include('cookies_modal')
  end
end
