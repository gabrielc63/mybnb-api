require 'rails_helper'

RSpec.describe 'Api::V1::Listings', type: :request do
  let(:user) { create(:user, email: 'faker@gmail.com', password: 'password') }
  let(:listing) { create(:listing, user: user) }
  let(:valid_attributes) do
    {
      listing: {
        title: 'Beautiful Beach House',
        description: 'A wonderful house right on the beach with amazing views',
        price_per_night: 150,
        bedrooms: 3,
        bathrooms: 2,
        max_guests: 6,
        property_type: 'house',
        address: '123 Beach Road'
      }
    }
  end

  before do
  end

  describe 'GET /index' do
    before do
      create_list(:listing, 3)
      get api_v1_listings_path
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns all listings' do
      expect(json['data'].size).to eq(3)
    end
  end

  describe 'GET /show' do
    before { get api_v1_listing_path(listing) }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the listing' do
      expect(json['data']['id'].to_i).to eq(listing.id)
    end
  end

  describe 'POST /create' do
    context 'when user is authenticated' do
      before do
        sign_in user
        post api_v1_listings_path, params: valid_attributes
      end

      it 'creates a new listing' do
        expect(response).to have_http_status(:created)
        expect(Listing.count).to eq(1)
      end
    end

    context 'when user is not authenticated' do
      before { post api_v1_listings_path, params: valid_attributes }

      it 'returns unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /update' do
    let(:new_attributes) { { listing: { title: 'Updated Title' } } }

    context 'when user is authenticated and owns the listing' do
      before do
        sign_in user
        put api_v1_listing_path(listing), params: new_attributes
      end

      it 'updates the listing' do
        expect(response).to have_http_status(:success)
        expect(listing.reload.title).to eq('Updated Title')
      end
    end

    context 'when user is not authenticated' do
      before { put api_v1_listing_path(listing), params: new_attributes }

      it 'returns unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when user is authenticated and owns the listing' do
      before do
        sign_in user
        delete api_v1_listing_path(listing)
      end

      it 'deletes the listing' do
        expect(response).to have_http_status(:no_content)
        expect(Listing.count).to eq(0)
      end
    end

    context 'when user is not authenticated' do
      before { delete api_v1_listing_path(listing) }

      it 'returns unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
