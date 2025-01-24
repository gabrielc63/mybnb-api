require 'rails_helper'

RSpec.describe Booking, type: :model do
  let(:booking) { build(:booking) }

  describe 'validations' do
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
    it { should validate_presence_of(:number_of_guests) }

    describe 'custom validations' do
      context 'end_date_after_start_date' do
        it 'is valid when end date is after start date' do
          expect(booking).to be_valid
        end

        it 'is invalid when end date is before start date' do
          booking.end_date = booking.start_date - 1.day
          expect(booking).not_to be_valid
        end
      end

      context 'guest_count_within_limit' do
        it 'is valid when guests are within limit' do
          booking.listing.max_guests = 4
          booking.number_of_guests = 2
          expect(booking).to be_valid
        end

        it 'is invalid when guests exceed limit' do
          booking.listing.max_guests = 2
          booking.number_of_guests = 4
          expect(booking).not_to be_valid
        end
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:listing) }
  end

  describe 'scopes' do
    let!(:upcoming_booking) { create(:booking, start_date: 1.week.from_now) }
    let!(:current_booking) { create(:booking, start_date: Date.today, end_date: 3.days.from_now) }
    let!(:past_booking) { create(:booking, :completed) }

    describe '.upcoming' do
      it 'returns future bookings' do
        expect(Booking.upcoming).to include(upcoming_booking)
        expect(Booking.upcoming).not_to include(past_booking)
      end
    end

    describe '.current' do
      it 'returns ongoing bookings' do
        expect(Booking.current).to include(current_booking)
        expect(Booking.current).not_to include(upcoming_booking)
      end
    end

    describe '.past' do
      it 'returns completed bookings' do
        expect(Booking.past).to include(past_booking)
        expect(Booking.past).not_to include(upcoming_booking)
      end
    end
  end

  describe '#duration' do
    it 'calculates the correct duration' do
      booking.start_date = Date.today
      booking.end_date = Date.today + 3.days
      expect(booking.duration).to eq(3)
    end
  end

  describe '#total_price' do
    it 'calculates the correct total price' do
      booking.start_date = Date.today
      booking.end_date = Date.today + 3.days
      booking.listing.price_per_night = 100
      expect(booking.total_price).to eq(300)
    end
  end
end
