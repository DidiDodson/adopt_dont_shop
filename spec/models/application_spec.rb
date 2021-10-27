require "rails_helper"

RSpec.describe Application, type: :model do
  describe "relationships" do
    it { should have_many :pets_applications}
    it { should have_many(:pets).through(:pets_applications)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_numericality_of(:zip_code) }
    # it { should validate_presence_of(:description) }
  end

  describe 'methods' do
    it 'should set default application status' do
      admin = Admin.create
      shelter_1 = admin.shelters.create!(name: "Dumb Friends League",
                                  rank: 2,
                                  city: "Honolulu",
                                  foster_program: true)

      pet_1 = shelter_1.pets.create!(name: "Mochi",
                          adoptable: true,
                          age: 2,
                          breed: "American Shorthair")

      application_1 = Application.create!(name: "Mary Tanaka",
                                          street_address: "123 Kapiolani Blvd.",
                                          city: "Honolulu",
                                          state: "HI",
                                          zip_code: "98684",
                                          description: "I'm a pet lover!")

      application_1.app_status

      expect(application_1.application_status).to eq("In Progress")
    end

    it 'should update attribute status' do
      admin = Admin.create
      shelter_1 = admin.shelters.create!(name: "Dumb Friends League",
                                  rank: 2,
                                  city: "Honolulu",
                                  foster_program: true)

      pet_1 = shelter_1.pets.create!(name: "Mochi",
                          adoptable: true,
                          age: 2,
                          breed: "American Shorthair")

      application_1 = Application.create!(name: "Mary Tanaka",
                                          street_address: "123 Kapiolani Blvd.",
                                          city: "Honolulu",
                                          state: "HI",
                                          zip_code: "98684",
                                          description: "I'm a pet lover!")

      application_1.app_status
      expect(application_1.application_status).to eq("In Progress")

      application_1.update_status("Pending")
      expect(application_1.application_status).to eq("Pending")
    end
  end
end
