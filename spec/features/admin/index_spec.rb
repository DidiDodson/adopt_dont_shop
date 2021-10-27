require 'rails_helper'

RSpec.describe 'admin index' do
  it 'shows admins' do
    admin = Admin.create
    visit "/admin/shelters"

    expect(page).to have_content(admin.id)
  end

  it 'shows shelters in descending order by name' do
    admin = Admin.create
    shelter_1 = admin.shelters.create!(name: "Cats R Us",
                                rank: 2,
                                city: "Honolulu",
                                foster_program: true)
    shelter_2 = admin.shelters.create!(name: "Dumb Friends League",
                                rank: 5,
                                city: "Kona",
                                foster_program: true)

    pet_1 = shelter_1.pets.create!(name: "Mochi",
                        adoptable: true,
                        age: 2,
                        breed: "American Shorthair")
    pet_2 = shelter_2.pets.create!(name: "Dango",
                        adoptable: true,
                        age: 4,
                        breed: "Bengal")
    application_1 = Application.create!(name: "Mary Tanaka",
                                        street_address: "123 Kapiolani Blvd.",
                                        city: "Honolulu",
                                        state: "HI",
                                        zip_code: "98684")

    visit "/admin/shelters"

    expect(page).to have_content(shelter_1.name)
    expect(shelter_2.name).to appear_before(shelter_1.name)
  end

  it 'shows shelters with Pending applications' do
    admin = Admin.create
    shelter_1 = admin.shelters.create!(name: "Dumb Friends League",
                                rank: 2,
                                city: "Honolulu",
                                foster_program: true)
    shelter_2 = admin.shelters.create!(name: "Cats R Us",
                                rank: 5,
                                city: "Kona",
                                foster_program: true)

    pet_1 = shelter_1.pets.create!(name: "Mochi",
                        adoptable: true,
                        age: 2,
                        breed: "American Shorthair")
    pet_2 = shelter_1.pets.create!(name: "Dango",
                        adoptable: true,
                        age: 4,
                        breed: "Bengal")
    application_1 = Application.create!(name: "Mary Tanaka",
                                        street_address: "123 Kapiolani Blvd.",
                                        city: "Honolulu",
                                        state: "HI",
                                        zip_code: "98684")

    visit "/applications/#{application_1.id}"

    fill_in 'search', with: "Moch"
    click_on("Search")

    within("#application_1-#{pet_1.id}") do
      click_on("Adopt this Pet")
    end

    fill_in "description", with: "I love Cats!"
    click_button "Submit"

    visit "/admin/shelters"

    within("#admins-#{shelter_1.id}") do
      expect(page).to have_content(shelter_1.name)
      expect(page).to_not have_content(shelter_2.name)
    end
  end
end
