# frozen_string_literal: true

class TurboProfileComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(title:, user:, modal_class: nil)
    super
    @title = title
    @user  = user
    @modal_class = modal_class
  end
end
