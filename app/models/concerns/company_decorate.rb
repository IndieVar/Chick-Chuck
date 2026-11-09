# frozen_string_literal: true

module CompanyDecorate
  extend ActiveSupport::Concern

  included do
    # Decorators
    def user_name
      title
    end

    def avatar_thumb
      avatar_url(:thumb, '/android-chrome-512x512.png')
    end

    def avatar_medium
      avatar_url(:medium, 'logo/og-chick-chuck.webp')
    end

    def avatar_large
      avatar_url(:large, 'logo/og-chick-chuck.webp')
    end

    private

    def avatar_url(size, fallback)
      avatar.present? ? avatar.public_send(size).url : fallback
    end
  end
end
