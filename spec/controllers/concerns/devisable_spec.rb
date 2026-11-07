# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Devisable do
  describe '#after_sign_in_path_for' do
    let(:controller) { ApplicationController.new }

    before do
      allow(controller).to receive(:current_user).and_return(double(user_name: 'Demo User'))
      allow(controller).to receive(:flash).and_return({})
      allow(controller).to receive(:request).and_return(double(referer: nil))
      allow(controller).to receive(:root_path).and_return('/')
    end

    it 'falls back to the root page when no referer is present' do
      expect(controller.send(:after_sign_in_path_for, nil)).to eq('/')
    end
  end
end
