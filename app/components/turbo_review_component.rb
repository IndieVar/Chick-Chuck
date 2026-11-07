# frozen_string_literal: true

class TurboReviewComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(title:)
    super
    @title = title
  end
end
