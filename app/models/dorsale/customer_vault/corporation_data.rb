class Dorsale::CustomerVault::CorporationData < Dorsale::CustomerVault::PersonData
  attribute :legal_form,                String
  attribute :immatriculation_number_1,  String
  attribute :immatriculation_number_2,  String
  attribute :european_union_vat_number, String
  attribute :capital,                   Integer
end

