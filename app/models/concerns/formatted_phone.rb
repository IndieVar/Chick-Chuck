# frozen_string_literal: true

module FormattedPhone
  extend ActiveSupport::Concern

  PHONE_ATTRIBUTES = %i[phone additional_phone whatsapp].freeze

  included do
    before_validation :normalize_phone_numbers

    validates :phone, uniqueness: true, allow_blank: true
    validate :validate_phone_numbers

    def formatted_phone
      format_phone(phone, phone_country)
    end

    def formatted_additional_phone
      format_phone(additional_phone, additional_phone_country)
    end

    def formatted_whatsapp
      format_phone(whatsapp, whatsapp_country)
    end

    PHONE_ATTRIBUTES.each do |attribute|
      define_method("#{attribute}_country") do
        selected_country = instance_variable_get("@#{attribute}_country")
        selected_country || Phonelib.parse(public_send(attribute)).country || Phonelib.default_country
      end

      define_method("#{attribute}_country=") do |country|
        selected_country = country.to_s.upcase
        value = Phonelib.phone_data.key?(selected_country) ? selected_country : Phonelib.default_country
        instance_variable_set("@#{attribute}_country", value)
      end
    end

    private

    def format_phone(phone, country)
      parsed_phone = Phonelib.parse(phone, country)
      return phone if parsed_phone.invalid?

      formatted = parsed_phone.country_code == '1' ? parsed_phone.full_national : parsed_phone.full_international
      formatted.gsub(';', ' x')
    end

    def normalize_phone_numbers
      PHONE_ATTRIBUTES.each do |attribute|
        value = public_send(attribute)
        next if value.blank?

        parsed_phone = Phonelib.parse(value, public_send("#{attribute}_country"))
        public_send("#{attribute}=", parsed_phone.full_e164) if parsed_phone.valid?
      end
    end

    def validate_phone_numbers
      PHONE_ATTRIBUTES.each do |attribute|
        value = public_send(attribute)
        next if value.blank? || Phonelib.parse(value, public_send("#{attribute}_country")).valid?

        errors.add(attribute, :invalid)
      end
    end
  end
end
