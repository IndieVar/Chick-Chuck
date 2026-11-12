# frozen_string_literal: true

class TurboModalComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(title:, variant: nil)
    super
    @title = title
    @variant = variant
  end

  def auth_modal?
    @variant == :auth
  end
end
