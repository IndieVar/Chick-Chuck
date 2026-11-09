# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClientDecorate, type: :model do
  subject(:client) { Client.new(gender:) }

  let(:gender) { 'female' }

  it 'uses the gender-specific fallback for all avatar sizes' do
    expect([client.avatar_thumb, client.avatar_medium, client.avatar_large]).to all(eq('icons/avatar-f.png'))
    client.gender = nil
    expect([client.avatar_thumb, client.avatar_medium, client.avatar_large]).to all(eq('icons/avatar-m.png'))
  end

  it 'uses the uploaded avatar variant when no remote avatar is set' do
    uploader = double(
      present?: true,
      thumb: double(url: '/thumb.png'),
      medium: double(url: '/medium.png'),
      large: double(url: '/large.png')
    )
    allow(client).to receive_messages(avatar: uploader, remote_avatar_url: nil)

    expect(client.avatar_thumb).to eq('/thumb.png')
    expect(client.avatar_medium).to eq('/medium.png')
    expect(client.avatar_large).to eq('/large.png')
  end
end

RSpec.describe ClientDecorate, type: :model do
  subject(:client) { Client.new(gender: 'female') }

  it 'prefers the remote avatar when an uploaded avatar is present' do
    allow(client).to receive_messages(
      avatar: double(present?: true),
      remote_avatar_url: 'https://example.test/avatar'
    )

    expect(client.avatar_thumb).to eq('https://example.test/avatar')
    expect(client.avatar_medium).to eq('https://example.test/avatar')
    expect(client.avatar_large).to eq('https://example.test/avatar')
  end
end
