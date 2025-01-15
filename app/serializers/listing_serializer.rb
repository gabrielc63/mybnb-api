class ListingSerializer
  include JSONAPI::Serializer

  attributes :title, :description, :price_per_night,
             :bedrooms, :bathrooms, :max_guests,
             :property_type, :address, :latitude, :longitude,
             :created_at, :updated_at

  attribute :average_rating do |object|
    object.average_rating
  end

  attribute :photos_urls do |object|
    object.photos.map { |photo| Rails.application.routes.url_helpers.url_for(photo) }
  end

  belongs_to :user
  # has_many :reviews
end
