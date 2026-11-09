# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'feedbacks/rooms/_room', type: :view do
  it 'renders the other participant and the latest message with its unread count' do
    current_user = Client.create!(
      email: 'room-view-current@example.test',
      password: 'valid-password',
      confirmed_at: Time.current
    )
    recipient = Client.create!(
      email: 'room-view-recipient@example.test',
      password: 'valid-password',
      first_name: 'Chat',
      last_name: 'Partner',
      confirmed_at: Time.current
    )
    room = Room.create!(users: [current_user, recipient])
    room.messages.build(user: recipient, content: 'Latest chat message', readed: false)

    render partial: 'feedbacks/rooms/room', locals: { room:, current_user: }

    expect(rendered).to include('Chat Partner', 'Latest chat message')
    expect(rendered).to include('bg-red-500')
  end
end
