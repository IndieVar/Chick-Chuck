# frozen_string_literal: true

class Company < User
  include CompanyDecorate
  validates :title, uniqueness: true, presence: true
  validates :districts, :languages, presence: true
  validates :description, length: { maximum: 1000 }
  validates :rating, numericality: { in: 0..5 }

  belongs_to :city
  has_rich_text :description
  # mount_uploaders :images, ImageUploader
  has_and_belongs_to_many :districts, class_name: 'District', foreign_key: :user_id
  has_and_belongs_to_many :languages, class_name: 'Language', foreign_key: :user_id
  has_and_belongs_to_many :services,  class_name: 'Service',  foreign_key: :user_id
  has_and_belongs_to_many :rooms,     class_name: 'Room',     foreign_key: :user_id, dependent: :destroy
  has_one  :calculator, class_name: 'Calculator', dependent: :destroy, foreign_key: :user_id
  has_many :products,   class_name: 'Product', dependent: :destroy, foreign_key: :user_id
  has_many :prices,     class_name: 'Price', dependent: :destroy, foreign_key: :user_id
  has_many :reviews,  as: :reviewable,  dependent: :destroy, class_name: 'Review'
  has_many :commentable_comments, as: :commentable, dependent: :destroy, class_name: 'Comment'
  has_many :comments, as: :object, dependent: :destroy, class_name: 'Comment'
  has_many :images,   as: :imageable,   dependent: :destroy, class_name: 'Image'
  accepts_nested_attributes_for :images

  # Scopes
  scope :confirmed, -> { where.not(confirmed_at: nil).order(rating: :desc) }
  scope :with_directory_details, -> { includes(:districts, :languages, :rich_text_description) }
  scope :filter_by_district_id, ->(district_id) { joins(:districts).where(districts: { id: district_id }).distinct }
  scope :filter_by_language_id, ->(language_id) { joins(:languages).where(languages: { id: language_id }).distinct }
  scope :filter_by_service_ids, ->(service_ids) { joins(:services).where(services: { id: service_ids }).distinct }

  after_destroy :clear_favorites

  def refresh_ratings
    rating, price = reviews.pick('AVG(rating)', 'AVG(price)')

    update(rating: rating&.round(1) || 0, price: price&.round(1) || 0)
  end

  private

  def clear_favorites
    Favorite.for_favorited_record(self).delete_all
  end
end
