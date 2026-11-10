# frozen_string_literal: true

class NewsDecorator < ApplicationDecorator
  include LocalizedCount
  delegate_all

  def created_at
    l news.created_at, format: :short
  end

  def comments_count
    localized_count(news.comments.count, :comments)
  end
end
