# frozen_string_literal: true

module Users
  class ProductsController < ApplicationController
    include Feedbacks::ReviewsHelper
    layout 'profile_layout'
    before_action :authenticate_user!, except: :new
    before_action :set_product, only: %i[edit update publish mark_as_sold destroy]
    before_action :filter_product, only: %i[new create edit update]

    def index
      @pagy, @products = pagy(current_user.products.newest, items: 8, fragment: '#products')
      @products = @products.decorate
    end

    def new
      unless client_signed_in? || company_signed_in?
        return redirect_to new_client_session_path,
                           alert: t('devise.failure.unauthenticated')
      end

      @product = current_user.products.new.decorate
    end

    def create
      @product = current_user.products.build(product_params).decorate

      respond_to do |format|
        if @product.save
          helpers.upload_image(@product)
          format.turbo_stream do
            flash.now[:success] = t('flash.success.created', model: "#{@product.model_name.human} #{@product.title}")
          end
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    def edit; end

    def update
      respond_to do |format|
        if @product.update(product_params)
          helpers.upload_image(@product)
          format.turbo_stream do
            flash.now[:success] = t('flash.success.updated', model: "#{@product.model_name.human} #{@product.title}")
          end
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    def publish
      return unless current_user.products.include?(@product)

      respond_to do |format|
        if @product.published == false
          if @product.update(published: true)
            format.turbo_stream do
              flash.now[:success] =
                t('flash.success.published', model: "#{@product.model_name.human} #{@product.title}")
            end
          end
        elsif @product.update(published: false)
          format.turbo_stream do
            flash.now[:success] = t('flash.success.hided', model: "#{@product.model_name.human} #{@product.title}")
          end
        end
      end
    end

    def mark_as_sold
      return unless current_user.products.include?(@product)

      respond_to do |format|
        if @product.sold == false
          @product.update(sold: true, published: false)
          format.turbo_stream do
            flash.now[:success] = t('flash.success.hided', model: "#{@product.model_name.human} #{@product.title}")
          end
        else
          @product.update(sold: false, published: true)
          format.turbo_stream do
            flash.now[:success] =
              t('flash.success.published', model: "#{@product.model_name.human} #{@product.title}")
          end
        end
      end
    end

    def destroy
      respond_to do |format|
        if @product.destroy
          format.turbo_stream { flash.now[:success] = t('flash.success.destroyed', model: @product.model_name.human) }
        else
          format.html { render :index, status: :unprocessable_entity }
        end
      end
    end

    private

    def product_params
      params.require(:product).permit(:category_id, :thing_id, :district_id, :city_id, :title, :condition, :delivery,
                                      :description, :price, { images_attributes: %i[id file] })
    end

    def filter_product
      @categories = Category.where.not(en: 'Cartons').decorate
      @districts = District.excluding_all_israel.decorate
    end

    def set_product
      @product = Product.find_by_id(params[:product_id] || params[:id]).decorate
    end
  end
end
