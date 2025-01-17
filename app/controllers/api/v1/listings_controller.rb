module Api
  module V1
    class ListingsController < ApplicationController
      def index
        @listings = Listing.all
        @listings = apply_filters(@listings)

        render json: ListingSerializer.new(@listings, { include: [:user] }).serializable_hash
      end

      def create
        @listing = current_user.listings.build(listing_params)

        if @listing.save
          render json: ListingSerializer.new(@listing).serializable_hash, status: :created
        else
          render json: {errors: @listing.errors}, status: :unprocessable_entity
        end
      end

      def show
        render json: ListingSerializer.new(@listing, { include: [:user, :reviews] }).serializable_hash
      end

      private
      
      def set_listing
        @listing = Listing.find(params[:id])
      end

      def listing_params
        params.require(:listing).permit(
          :title, :description, :price_per_night,
          :bedrooms, :bathrooms, :max_guests,
          :property_type, :address, :latitude, :longitude,
          photos: [], amenities: []
        )
      end

      def apply_filters(listings)
        if params[:min_price] && params[:max_price]
          listings = listings.price_range(params[:min_price],
                                          params[:max_price])
        end
        listings = listings.by_property_type(params[:property_type]) if params[:property_type]
        listings = listings.by_rooms(params[:bedrooms]) if params[:bedrooms]
        if params[:latitude] && params[:longitude]
          listings = listings.by_location(params[:latitude], params[:longitude],
                                          params[:radius])
        end
        listings
      end
    end
  end
end
