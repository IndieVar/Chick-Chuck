# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_context 'feedback request helpers' do
  def create_feedback(user:, title:, content:)
    feedback = { user_id: user.id, title:, content: }
    feedback.merge!(informative: false, problems: false, created_at: Time.current, updated_at: Time.current)
    Feedback.insert_all!([feedback])
  end
end

RSpec.describe 'Feedback rating page', type: :request do
  before do
    host! 'example.com'
  end

  it 'renders when no feedback has been submitted' do
    Feedback.delete_all

    get '/feedbacks'

    expect(response).to have_http_status(:ok)
  end

  it 'selects an available locale from a regional language header' do
    get '/feedbacks', headers: { 'HTTP_ACCEPT_LANGUAGE' => 'ru-RU, en-US;q=0.8' }

    expect(response).to have_http_status(:ok)
    expect(response.headers['Content-Language']).to eq('ru')
  end
end

RSpec.describe 'Feedback review list', type: :request do
  include_context 'feedback request helpers'

  before do
    host! 'example.com'
  end

  it 'lists only feedback with both a title and content' do
    user = Client.create!(
      email: 'feedback-spec@example.test',
      password: 'valid-password',
      first_name: 'Demo',
      last_name: 'Client',
      confirmed_at: Time.current
    )
    create_feedback(user:, title: 'Missing content', content: nil)
    create_feedback(user:, title: 'Blank content', content: '')
    create_feedback(user:, title: nil, content: 'Missing title')
    create_feedback(user:, title: 'Visible feedback title', content: 'Visible feedback body')

    get '/feedbacks'

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('Visible feedback title', 'Visible feedback body')
    expect(response.body).not_to include('Missing content', 'Blank content', 'Missing title')
  end
end
