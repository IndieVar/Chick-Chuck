# frozen_string_literal: true

module Carrierwave
  class ImagesController < ApplicationController
    before_action :set_imageable

    def show
      if helpers.is_avatar?
        @images = [@imageable.avatar].select { |avatar| avatar&.url.present? }
      else
        @images = @imageable.images.select { |image| image.file&.url.present? }
        start_index = params[:id].to_i
        @images = @images.select do |img|
          img.id >= start_index
        end + @images.select do |img|
          img.id < start_index
        end
      end
    end

    def destroy
      @image = Image.find(params[:id])
      respond_to do |format|
        if @image.destroy
          format.turbo_stream do
            flash[:success] = t('flash.success.destroyed', model: t('global.image'))
            redirect_to request.referer
          end
        else
          format.turbo_stream do
            flash[:error] = t('flash.alert')
            redirect_to request.referer
          end
        end
      end
    end

    private

    def set_imageable
      @imageable = helpers.is_avatar? ? User.find(params[:id]) : Image.find(params[:id]).imageable
    end
  end
end
