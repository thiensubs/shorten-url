# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MyLink, type: :model do
  it { is_expected.to be_mongoid_document }
  it { is_expected.to have_timestamps }
  it {
    list_class_validations = MyLink.validators.map{|e| e.class.to_s}
    MyLink.validators.each do |validate|
      expect(list_class_validations).to     include(validate.class.to_s)
    end
  }
  describe 'validation precense' do
    MyLink.validators.each do |e|
      if e.class.to_s == 'Mongoid::Validatable::PresenceValidator'
        e.attributes.each do |attribute|
          it { should validate_presence_of(attribute) }
        end
      end
    end
  end
end
