# frozen_string_literal: true

module FormattedPhone
  extend ActiveSupport::Concern

  included do
    before_save :normalize_phone

    validates :phone, phone: true, allow_blank: true, uniqueness: true
    validates :additional_phone, phone: true, allow_blank: true
    validates :whatsapp, phone: true, allow_blank: true

    def formatted_phone
      format_phone(phone)
    end

    def formatted_additional_phone
      format_phone(additional_phone)
    end

    def formatted_whatsapp
      format_phone(whatsapp)
    end

    private

    def format_phone(phone)
      parsed_phone = Phonelib.parse(phone)
      return phone if parsed_phone.invalid?

      formatted = parsed_phone.country_code == '1' ? parsed_phone.full_national : parsed_phone.full_international
      formatted.gsub(';', ' x')
    end

    def normalize_phone
      self.phone = Phonelib.parse(phone).full_e164.presence
      self.additional_phone = Phonelib.parse(additional_phone).full_e164.presence
      self.whatsapp = Phonelib.parse(whatsapp).full_e164.presence
    end
  end
end
