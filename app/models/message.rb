# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many :images, as: :imageable, dependent: :destroy, class_name: 'Image'
  accepts_nested_attributes_for :images

  scope :unread, -> { where(readed: false).count }

  has_noticed_notifications

  after_create_commit :notify_user

  def notify_user
    MessageNotification.with(message: self).deliver_later(recipient)
  end

  def recipient
    room.recipient(user)
  end
end
