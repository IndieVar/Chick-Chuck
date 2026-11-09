# frozen_string_literal: true

class Room < ApplicationRecord
  has_and_belongs_to_many :users

  has_many :messages, class_name: 'Message', dependent: :destroy

  before_create { self.title = SecureRandom.hex(5) }

  scope :with_user_named, lambda { |name|
    joins(:users).merge(User.filter_by_exact_user_name(name)).distinct
  }

  def recipient(user)
    users.where.not(id: user).first
  end
end
