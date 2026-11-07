# frozen_string_literal: true

module Devisable
  extend ActiveSupport::Concern

  included do
    devise_group :user, contains: %i[admin client company]
    before_action :configure_sign_up_params, only: [:create], if: :devise_controller?
  end

  protected

  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up) { |client| client.permit(permitted_attributes) }
    devise_parameter_sanitizer.sanitize(:sign_up) { |company| company.permit(permitted_attributes) }
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: permitted_attributes)
    devise_parameter_sanitizer.permit :sign_in, keys: %i[login password]
  end

  def permitted_attributes
    [:email, :phone, :password, :password_confirmation,
     :first_name, :last_name, :avatar, :remove_avatar, :gender, :birthday, :city_id, :locale,
     :additional_phone, :whatsapp, :telegram, :facebook, :title, :website, :description, { district_ids: [], language_ids: [], service_ids: [] }]
  end

  def after_sign_in_path_for(_resource)
    flash[:success] = "You are welcome, #{current_user.user_name}!"
    referer = request.referer.to_s

    if referer.include?('/clients/sign_in')        ||
       referer.include?('/clients/sign_up')        ||
       referer.include?('/clients/password')       ||
       referer.include?('/clients/confirmation')   ||
       referer.include?('/clients/sign_out')       ||
       referer.include?('/clients/auth')           ||
       referer.include?('https://accounts.google.com/') ||
       referer.include?('https://www.facebook.com/')    ||
       referer.include?('/companies/sign_in')      ||
       referer.include?('/companies/sign_up')      ||
       referer.include?('/companies/password')     ||
       referer.include?('/companies/confirmation') ||
       referer.include?('/companies/sign_out')     ||
       referer.include?('/companies/auth')         ||
       referer.include?('/admins/sign_in')         ||
       referer.include?('/admins/sign_up')         ||
       referer.include?('/admins/password')        ||
       referer.include?('/admins/confirmation')    ||
       referer.include?('/admins/sign_out')        ||
       referer.include?('/admins/auth')

      root_path
    else
      referer.presence || root_path
    end
  end
end
