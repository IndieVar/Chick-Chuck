# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompanyDecorate, type: :model do
  subject(:company) { Company.new }

  it 'uses the existing fallback assets for each avatar size' do
    expect(company.avatar_thumb).to eq('/android-chrome-512x512.png')
    expect(company.avatar_medium).to eq('logo/og-chick-chuck.webp')
    expect(company.avatar_large).to eq('logo/og-chick-chuck.webp')
  end

  it 'uses the corresponding uploaded avatar variant' do
    uploader = double(
      present?: true,
      thumb: double(url: '/thumb.png'),
      medium: double(url: '/medium.png'),
      large: double(url: '/large.png')
    )
    allow(company).to receive(:avatar).and_return(uploader)

    expect(company.avatar_thumb).to eq('/thumb.png')
    expect(company.avatar_medium).to eq('/medium.png')
    expect(company.avatar_large).to eq('/large.png')
  end
end
