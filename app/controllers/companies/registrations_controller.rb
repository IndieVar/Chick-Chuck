# frozen_string_literal: true

module Companies
  class RegistrationsController < Devise::RegistrationsController
    layout 'profile_layout', except: %i[new create]
    before_action :configure_sign_up_params, only: [:create], if: :devise_controller?
    before_action :configure_account_update_params, only: [:update], if: :devise_controller?

    # GET /resource/sign_up
    def new
      set_meta_tags(
        title: t('meta.company.sign_up.title'),
        description: t('meta.company.sign_up.desc'),
        noindex: true
      )
      super
      # build_resource({})
      # resource.build_profile
      # respond_with resource
    end

    # POST /resource
    # def create
    #    super
    #  end

    # GET /resource/edit
    # def edit
    #   super
    # end

    # PUT /resource
    # def update
    #    super
    #  end

    # DELETE /resource
    def destroy
      super do
        # Turbo requires redirects be :see_other (303); so override Devise default (302)
        return redirect_to root_path, status: :see_other
      end
    end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the company wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    def cancel
      expire_data_after_sign_in!
      redirect_to root_path
    end

    protected

    # If you have extra params to permit, append them to the sanitizer.

    def sign_up_params
      devise_parameter_sanitizer.sanitize(:sign_up) { |company| company.permit(permitted_attributes) }
    end

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: permitted_attributes)
    end

    def permitted_attributes
      [:email, :phone, :password, :password_confirmation,
       :first_name, :last_name, :avatar, :remove_avatar, :gender, :birthday, :city_id, :locale,
       :additional_phone, :whatsapp, :telegram, :facebook, :title, :website, :description, { district_ids: [], language_ids: [], service_ids: [] }]
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: permitted_attributes)
    end

    def after_update_path_for(_resource)
      edit_company_registration_path
    end

    def after_inactive_sign_up_path_for(resource)
      new_confirmation_path(resource)
    end

    # The path used after sign up.
    # def after_sign_up_path_for(_resource)
    #       flash[:success] = "You are welcome, #{current_company.title}!" if company_signed_in?
    #       root_path
    #     end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end
  end
end
