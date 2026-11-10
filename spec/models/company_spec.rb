# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'favorite cleanup' do
    it 'deletes favorites without instantiating each favorite record' do
      district = District.create!(ru: 'Округ', en: 'District', he: 'מחוז', uk: 'Округ')
      city = City.create!(ru: 'Город', en: 'City', he: 'עיר', uk: 'Місто', district:)
      language = Language.create!(title: 'English')
      company = Company.create!(
        email: 'favorite-company@example.test',
        password: 'valid-password',
        title: 'Favorite Company',
        city:,
        districts: [district],
        languages: [language]
      )
      client = Client.create!(email: 'favorite-client@example.test', password: 'valid-password')
      Favorite.create!(user: client, favorited_type: Company.name, favorited_id: company.id)

      expect { company.destroy }.to change(Favorite, :count).by(-1)
    end
  end
end

RSpec.describe Company, type: :model do
  describe '.with_directory_details' do
    it 'preloads the company card associations' do
      district = District.create!(ru: 'Округ', en: 'District', he: 'מחוז', uk: 'Округ')
      city = City.create!(ru: 'Город', en: 'City', he: 'עיר', uk: 'Місто', district:)
      language = Language.create!(title: 'English')
      company = Company.create!(
        email: 'directory-company@example.test',
        password: 'valid-password',
        title: 'Directory Company',
        city:,
        districts: [district],
        languages: [language],
        confirmed_at: Time.current
      )

      loaded_company = described_class.with_directory_details.find(company.id)

      expect(loaded_company.association(:districts)).to be_loaded
      expect(loaded_company.association(:languages)).to be_loaded
      expect(loaded_company.association(:rich_text_description)).to be_loaded
    end
  end
end

RSpec.describe Company, type: :model do
  describe 'comment associations' do
    it 'uses the correct polymorphic foreign keys for each comment role' do
      company = described_class.new(id: 1)

      commentable_comment = company.commentable_comments.build
      root_comment = company.comments.build

      expect(commentable_comment.commentable_id).to eq(company.id)
      expect(commentable_comment.commentable_type).to eq(described_class.polymorphic_name)
      expect(commentable_comment.user_id).to be_nil
      expect(root_comment.object_id).to eq(company.id)
      expect(root_comment.object_type).to eq(described_class.polymorphic_name)
      expect(root_comment.user_id).to be_nil
    end
  end
end

RSpec.describe Company, type: :model do
  describe 'directory filters' do
    it 'includes companies serving all Israel when a specific district is selected' do
      district = District.create!(ru: 'Северный округ', en: 'Northern District', he: 'מחוז הצפון',
                                  uk: 'Північний округ')
      all_israel = District.create!(ru: 'Весь Израиль', en: 'All Israel', he: 'כל ישראל',
                                    uk: 'Весь Ізраїль')
      city = City.create!(ru: 'Город', en: 'City', he: 'עיר', uk: 'Місто', district:)
      language = Language.create!(title: 'English')
      local_company = Company.create!(
        email: 'local-district-company@example.test',
        password: 'valid-password',
        title: 'Local District Company',
        city:,
        districts: [district],
        languages: [language]
      )
      nationwide_company = Company.create!(
        email: 'nationwide-company@example.test',
        password: 'valid-password',
        title: 'Nationwide Company',
        city:,
        districts: [all_israel],
        languages: [language]
      )

      filtered_ids = described_class.filter_by_district_id(district.id).pluck(:id)

      expect(filtered_ids).to contain_exactly(local_company.id, nationwide_company.id)
    end

    it 'does not duplicate companies when district and language joins combine' do
      district = District.create!(ru: 'Округ', en: 'District', he: 'מחוז', uk: 'Округ')
      second_district = District.create!(ru: 'Округ 2', en: 'District 2', he: 'מחוז 2', uk: 'Округ 2')
      city = City.create!(ru: 'Город', en: 'City', he: 'עיר', uk: 'Місто', district:)
      language = Language.create!(title: 'English')
      second_language = Language.create!(title: 'Hebrew')
      company = Company.create!(
        email: 'filtered-company@example.test',
        password: 'valid-password',
        title: 'Filtered Company',
        city:,
        districts: [district, second_district],
        languages: [language, second_language]
      )
      other_district_company = Company.create!(
        email: 'other-district-company@example.test',
        password: 'valid-password',
        title: 'Other District Company',
        city:,
        districts: [second_district],
        languages: [language]
      )

      filtered_companies = described_class.filter_by_district_id(district.id)
      expect(filtered_companies.pluck(:id)).to contain_exactly(company.id)

      filtered_companies = filtered_companies.filter_by_language_id(language.id)

      expect(filtered_companies.where(id: company.id).count).to eq(1)
      expect(filtered_companies.where(id: other_district_company.id)).to be_empty
    end
  end
end

RSpec.describe Company, type: :model do
  describe '.filter_by_service_ids' do
    it 'does not filter companies when no service is selected' do
      expect(described_class.user_filter(service_ids: ['']).to_sql).not_to include('"services"')
    end

    it 'filters for a single selected service' do
      sql = described_class.filter_by_service_ids([3]).to_sql

      expect(sql).to include('"services"."id" = 3')
      expect(sql).to include('SELECT DISTINCT')
    end

    it 'filters for any of multiple selected services without duplicate companies' do
      sql = described_class.filter_by_service_ids([3, 5]).to_sql

      expect(sql).to include('"services"."id" IN (3, 5)')
      expect(sql).to include('SELECT DISTINCT')
    end
  end
end

RSpec.describe Company, type: :model do
  describe '#refresh_ratings' do
    it 'updates both aggregate ratings from one review query' do
      reviews = double
      company = described_class.new

      allow(company).to receive(:reviews).and_return(reviews)
      expect(reviews).to receive(:pick).with('AVG(rating)', 'AVG(price)').and_return([4.34, 2.76])
      expect(company).to receive(:update).with(rating: 4.3, price: 2.8)

      company.refresh_ratings
    end

    it 'resets ratings to zero when there are no reviews' do
      reviews = double
      company = described_class.new

      allow(company).to receive(:reviews).and_return(reviews)
      allow(reviews).to receive(:pick).with('AVG(rating)', 'AVG(price)').and_return([nil, nil])
      expect(company).to receive(:update).with(rating: 0, price: 0)

      company.refresh_ratings
    end
  end
end
