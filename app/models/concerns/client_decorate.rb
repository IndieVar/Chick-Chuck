# frozen_string_literal: true

module ClientDecorate
  extend ActiveSupport::Concern

  included do
    # Decorators
    def user_name
      return "#{first_name&.capitalize} #{last_name&.capitalize}" if first_name.present?

      email.split('@')[0].capitalize
    end

    def avatar_thumb
      avatar_for(:thumb)
    end

    def avatar_medium
      avatar_for(:medium)
    end

    def avatar_large
      avatar_for(:large)
    end

    private

    def avatar_for(size)
      return remote_avatar_url || avatar.public_send(size).url if avatar.present?

      gender == 'female' ? 'icons/avatar-f.png' : 'icons/avatar-m.png'
    end
  end
end
