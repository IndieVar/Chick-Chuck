# frozen_string_literal: true

class Product < ApplicationRecord
  include Filterable
  validates_associated :category, :thing, :district, :city
  validates :title, :condition, :delivery, :price, presence: true

  belongs_to :user, foreign_key: :user_id
  belongs_to :category
  belongs_to :thing
  belongs_to :district
  belongs_to :city
  has_many :images, as: :imageable, dependent: :destroy, class_name: 'Image'
  accepts_nested_attributes_for :images

  scope :published,             -> { where published: true }
  scope :filter_by_category_id, ->(category_id) { where category_id: }
  scope :filter_by_thing_id,    ->(thing_id)    { where thing_id: }
  scope :filter_by_district_id, ->(district_id) { where district_id: }
  scope :filter_by_city_id,     ->(city_id)     { where city_id: }
  scope :filter_by_condition,   ->(condition)   { where condition: }
  scope :filter_by_delivery,    ->(delivery)    { where delivery: }
  scope :filter_by_seller, ->(seller) { joins(:user).where(users: { type: seller }) }
  scope :filter_by_price_min,   ->(price_min)   { where 'price >= ?', price_min }
  scope :filter_by_price_max,   ->(price_max)   { where 'price <= ?', price_max }

  after_destroy :clear_favorites

  def self.condition_select
    [
      [I18n.t('product.condition.second_hand'), 1], [I18n.t('product.condition.new'), 2]
    ]
  end

  def self.delivery_select
    delivery_select = [
      [I18n.t('product.delivery.pickup'), 0]
    ]
    District.all.decorate.each do |district|
      delivery_select << [district.title, district.id]
    end
    delivery_select
  end

  def self.seller_select
    [
      [I18n.t('product.seller.client'), 'Client'], [I18n.t('product.seller.company'), 'Company']
    ]
  end

  private

  def clear_favorites
    Favorite.for_favorited_record(self, favorited_type: 'ProductDecorator').destroy_all
  end
end
