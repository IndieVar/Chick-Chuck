# frozen_string_literal: true

class Client < User
  include ClientDecorate
  devise :omniauthable, omniauth_providers: %i[facebook google_oauth2]

  has_many :products, class_name: 'Product', dependent: :destroy, foreign_key: :user_id

  def self.from_omniauth(auth)
    find_or_create_by!(email: auth.info.email) do |client|
      client.assign_attributes(omniauth_attributes(auth))
    end
  rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid
    find_by(email: auth.info.email) || raise
  end

  def self.omniauth_attributes(auth)
    name_parts = auth.info.name.split(' ')

    {
      provider: auth.provider,
      uid: auth.uid,
      password: Devise.friendly_token[0, 20],
      confirmed_at: Time.current,
      first_name: name_parts.first,
      last_name: name_parts.last
    }
  end
  private_class_method :omniauth_attributes

  def company_review(company)
    company.reviews.find_by(user_id: id)
  end

  # Mailer
  def after_confirmation
    Subscriber.find_or_create_by!(email:)
  end
end
