# frozen_string_literal: true

module Clients
  class ProfilesController < ApplicationController
    layout 'profile_layout'
    before_action :authenticate_client!
    before_action :set_profile, only: %i[edit update]

    def edit; end

    def update
      I18n.locale = set_profile_params[:locale] unless set_profile_params[:locale] == @user.locale
      respond_to do |format|
        if @user.update set_profile_params
          format.html do
            redirect_to edit_clients_profile_path, success: t('flash.success.updated', model: t('flash.account'))
          end
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    private

    def set_profile
      @user = current_client
    end

    def set_profile_params
      params.require(:client).permit(:first_name, :last_name, :avatar, :gender, :birthday, :city_id, :locale,
                                     :remove_avatar, :additional_phone, :additional_phone_country,
                                     :whatsapp, :whatsapp_country, :telegram, :facebook)
    end
  end
end
