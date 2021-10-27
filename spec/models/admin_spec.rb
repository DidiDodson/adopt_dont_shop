require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe 'relationships' do
    it { should have_many :shelters }
  end
end
