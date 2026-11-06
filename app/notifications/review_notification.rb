# frozen_string_literal: true

# To deliver this notification:
#
# CommentNotification.with(post: @post).deliver_later(current_user)
# CommentNotification.with(post: @post).deliver(current_user)

class ReviewNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  deliver_by :email, mailer: 'CompanyMailer'
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  param :review

  # Define helper methods to make rendering easier.
  #
  def message
    t('notification.review')
  end

  def review
    params[:review]
  end

  def available?
    review.present? && review.reviewable.present? && review.user.present?
  end

  def object
    review&.reviewable
  end

  def url
    return unless available?

    user_url(id: object.id, anchor: "review_#{review.id}")
  end

  def avatar
    review&.user&.avatar_thumb
  end

  def author
    review&.user&.user_name
  end
end
