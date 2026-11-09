# frozen_string_literal: true

class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :favorited, polymorphic: true

  scope :for_favorited_record, lambda { |record, favorited_type: record.class.name|
    where(favorited_type:, favorited_id: record.id)
  }
end
