require 'rails_helper'

RSpec.describe "the Pet Application new page" do
  it "assigns a pet to an application" do
    shelter_1 = Shelter.create!(name: "Dumb Friends League",
                                rank: 2,
                                city: "Honolulu",
                                foster_program: true)

    pet_1 = Pet.create!(name: "Mochi",
                        adoptable: true,
                        age: 2,
                        breed: "American Shorthair",
                        shelter_id: "#{shelter_1.id}")
    pet_2 = Pet.create!(name: "Mocha",
                        adoptable: true,
                        age: 3,
                        breed: "American Shorthair",
                        shelter_id: "#{shelter_1.id}")

    application_1 = Application.create!(name: "Mary Tanaka",
                                        street_address: "123 Kapiolani Blvd.",
                                        city: "Honolulu",
                                        state: "HI",
                                        zip_code: "98684",
                                        description: "I'm a pet lover!", application_status: "In Progress"
                                        )

    visit "/applications/#{application_1.id}"

    fill_in 'search', with: "Moch"
    click_on("Search")

    within("#application_1-#{pet_1.id}") do
      expect(page).to have_content(pet_1.name)
      expect(page).to have_link("Adopt this Pet")
      click_on("Adopt this Pet")
   end

    pet_1_app = PetsApplication.create!(pet_id: "#{pet_1.id}", application_id: "#{application_1.id}")

    expect(pet_1_app.pet_id).to eq(pet_1.id)
    expect(pet_1_app.pet_id).to_not eq(pet_2.id)
  end
end
