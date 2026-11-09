# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Filterable, type: :model do
  describe '.filter' do
    it 'starts with published records and applies the supplied scopes' do
      sql = Product.filter(category_id: 3, price_min: 10, seller: 'Company').to_sql

      expect(sql).to include('"products"."published" = TRUE')
      expect(sql).to include('"products"."category_id" = 3')
      expect(sql).to include('price >= 10')
      expect(sql).to include('"users"."type" = \'Company\'')
    end
  end
end

RSpec.describe Filterable, type: :model do
  describe '.user_filter' do
    it 'excludes admins and applies the supplied scopes' do
      sql = User.user_filter(type: 'Client').to_sql

      expect(sql).to include('"users"."type" != \'Admin\'')
      expect(sql).to include('"users"."type" = \'Client\'')
    end
  end
end

RSpec.describe Filterable, type: :model do
  describe '.user_filter with a name query' do
    it 'keeps user-name searches in the relation and composes them with other filters' do
      sql = User.newest.user_filter(type: 'Client', user_name: 'demo').to_sql

      expect(sql).to include('"users"."type" != \'Admin\'')
      expect(sql).to include('"users"."type" = \'Client\'')
      expect(sql).to include('LOWER(users.title) LIKE')
      expect(sql).to include('LOWER(CONCAT_WS')
      expect(sql).to include('LOWER(SPLIT_PART')
    end
  end
end

RSpec.describe Filterable, type: :model do
  describe '.user_filter matching client names' do
    it 'searches first and last names case-insensitively' do
      client = Client.create!(
        email: 'fullname-filter@example.test',
        password: 'valid-password',
        first_name: 'Demo',
        last_name: 'Carrier',
        confirmed_at: Time.current
      )

      expect(User.user_filter(user_name: 'demo car').to_a).to eq([client])
    end
  end
end

RSpec.describe Filterable, type: :model do
  describe '.user_filter matching email usernames' do
    it 'searches the email username when no first name is available' do
      client = Client.create!(
        email: 'named.filter@example.test',
        password: 'valid-password',
        confirmed_at: Time.current
      )

      expect(User.user_filter(user_name: 'named.fil').to_a).to eq([client])
    end
  end
end

RSpec.describe Filterable, type: :model do
  describe '.user_products_filter' do
    it 'limits results to the given seller and published products' do
      sql = Product.user_products_filter(7, condition: 2).to_sql

      expect(sql).to include('"products"."user_id" = 7')
      expect(sql).to include('"products"."published" = TRUE')
      expect(sql).to include('"products"."condition" = 2')
    end
  end
end
