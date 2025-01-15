class Listing < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many_attached :photos

  validates :title, presence: true, length: { minimum: 5, maximum: 100 }
  validates :description, presence: true, length: { minimum: 20, maximum: 2000 }
  validates :price_per_night, presence: true, numericality: { greater_than: 0 }
  validates :bedrooms, presence: true, numericality: { greater_than: 0 }
  validates :bathrooms, presence: true, numericality: { greater_than: 0 }
  validates :max_guests, presence: true, numericality: { greater_than: 0 }
  validates :property_type, presence: true
  validates :address, presence: true

  enum property_type: {
    house: 0,
    apartment: 1,
    guesthouse: 2,
    hotel: 3,
    villa: 4,
    cabin: 5
  }

  scope :price_range, ->(min, max) { where(price_per_night: min..max) }
  scope :by_property_type, ->(type) { where(property_type: type) }
  scope :by_rooms, ->(bedrooms) { where('bedrooms >= ?', bedrooms) }
  scope :by_location, lambda { |latitude, longitude, radius_km|
    where('ST_DWithin(location, ST_MakePoint(:longitude, :latitude)::geography, :radius)',
          longitude: longitude, latitude: latitude, radius: radius_km * 1000)
  }

  def average_rating
    # reviews.average(:rating)&.round(2) || 0
    0
  end
end
