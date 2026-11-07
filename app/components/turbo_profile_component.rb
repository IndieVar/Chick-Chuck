# frozen_string_literal: true

class TurboProfileComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(title:, user:)
    super
    @title = title
    @user  = user
  end
end
