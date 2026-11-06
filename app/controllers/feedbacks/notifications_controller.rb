# frozen_string_literal: true

module Feedbacks
  class NotificationsController < ApplicationController
    before_action :authenticate_user!, :set_notifications
    after_action :read_notifications

    def index; end

    private

    def set_notifications
      @notifications = current_user.notifications.where.not(type: MessageNotification.name)
      @visible_notifications = @notifications.select do |notification|
        content = notification.to_notification
        !content.respond_to?(:available?) || content.available?
      end
    end

    def read_notifications
      @notifications.update_all(read_at: Time.zone.now)
      current_user.broadcast_replace_to "broadcast_to_user_#{current_user.id}",
                                        target: 'notifications_count',
                                        partial: 'feedbacks/notifications/count',
                                        locals: { count: current_user.unviewed_notifications_count }
    end
  end
end
