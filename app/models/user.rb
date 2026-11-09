# frozen_string_literal: true

class User < ApplicationRecord
  include Login
  include FormattedPhone
  include Notificable
  include Filterable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable,
         :validatable, authentication_keys: [:login]

  mount_uploader :avatar, AvatarUploader

  validates :first_name, :last_name, allow_blank: true, length: { in: 2..25 }
  has_one :feedback, class_name: 'Feedback', dependent: :destroy
  has_and_belongs_to_many :rooms, class_name: 'Room', dependent: :destroy
  has_many :comments, class_name: 'Comment', dependent: :destroy
  has_many :messages, class_name: 'Message', dependent: :destroy
  has_many :reviews, class_name: 'Review', dependent: :destroy

  has_many :favorites, foreign_key: :user_id, dependent: :destroy

  # Scopes
  scope :filter_by_type, ->(type) { where type: }
  scope :filter_by_exact_user_name, lambda { |user_name|
    name = user_name.downcase
    where(
      <<~SQL.squish,
        LOWER(users.title) = :name
        OR (
          users.type = 'Client'
          AND CASE
            WHEN users.first_name IS NOT NULL AND users.first_name <> ''
              THEN LOWER(CONCAT(users.first_name, ' ', users.last_name))
            ELSE LOWER(SPLIT_PART(users.email, '@', 1))
          END = :name
        )
        OR (
          users.type = 'Admin'
          AND LOWER(CASE
            WHEN users.first_name IS NOT NULL AND users.first_name <> ''
              THEN CONCAT('Admin ', users.first_name)
            ELSE 'Admin'
          END) = :name
        )
      SQL
      name:
    )
  }
  scope :filter_by_user_name, lambda { |user_name|
    query = "%#{sanitize_sql_like(user_name.downcase)}%"
    where(
      <<~SQL.squish,
        LOWER(users.title) LIKE :query
        OR LOWER(CONCAT_WS(' ', users.first_name, users.last_name)) LIKE :query
        OR LOWER(SPLIT_PART(users.email, '@', 1)) LIKE :query
      SQL
      query:
    )
  }
end
