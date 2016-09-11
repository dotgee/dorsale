require 'rails_helper'

RSpec.describe ::Dorsale::CustomerVault::Corporation, type: :model do
    it { is_expected.to have_one(:address).dependent(:destroy) }
    it { is_expected.to have_many :comments }
    it { is_expected.to have_many :taggings }
    it { is_expected.to have_many :tags }
    it { is_expected.to have_many(:tasks).dependent(:destroy) }

    it { is_expected.to respond_to :legal_form }
    it { is_expected.to respond_to :capital }
    it { is_expected.to respond_to :immatriculation_number_1 }
    it { is_expected.to respond_to :immatriculation_number_2 }

    it { is_expected.to have_many(:comments).dependent(:destroy) }

    it { is_expected.to validate_presence_of :corporation_name }
end

