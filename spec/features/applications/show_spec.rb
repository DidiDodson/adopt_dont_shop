require 'rails_helper'

RSpec.describe "the Application show page" do
  it "should display an application" do
    shelter_1 = Shelter.create!(name: "Dumb Friends League",
                                rank: 2,
                                city: "Honolulu",
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
                                        zip_code: "98684",
                                        description: "I'm a pet lover!",
                                        application_status: "In Progress")

    application_1.pets << pet_1
    application_1.pets << pet_2

    visit "/applications/#{application_1.id}"

    expect(page).to have_content(application_1.name)
    expect(page).to have_content(application_1.street_address)
  end

  it "should return a pet after name search" do
    shelter_1 = Shelter.create!(name: "Dumb Friends League",
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
                                        description: "I'm a pet lover!", application_status: "In Progress"
                                        )

    visit "/applications/#{application_1.id}"

    expect(page).to have_content("Add a Pet to this Application")

    fill_in 'search', with: "Mochi"
    click_on("Search")

    expect(page).to have_content(pet_1.name)
  end

  it "should return multiple pets with partial search term" do
    shelter_1 = Shelter.create!(name: "Dumb Friends League",
                                rank: 2,
                                city: "Honolulu",
                                foster_program: true)

    pet_1 = shelter_1.pets.create!(name: "Mochi",
                        adoptable: true,
                        age: 2,
                        breed: "American Shorthair")
    pet_2 = shelter_1.pets.create!(name: "Mocha",
                        adoptable: true,
                        age: 3,
                        breed: "American Shorthair")

    application_1 = Application.create!(name: "Mary Tanaka",
                                        street_address: "123 Kapiolani Blvd.",
                                        city: "Honolulu",
                                        state: "HI",
                                        zip_code: "98684",
                                        description: "I'm a pet lover!", application_status: "In Progress"
                                        )

    visit "/applications/#{application_1.id}"

    expect(page).to have_content("Add a Pet to this Application")

    fill_in 'search', with: "Moch"
    click_on("Search")

    expect(page).to have_content(pet_1.name)
    expect(page).to have_content(pet_2.name)
  end

  it "should show a link to adopt" do
    shelter_1 = Shelter.create!(name: "Dumb Friends League",
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
                                        description: "I'm a pet lover!", application_status: "In Progress"
                                        )

    visit "/applications/#{application_1.id}"

    fill_in 'search', with: "Moch"
    click_on("Search")

    expect(page).to have_link("Adopt this Pet")
  end

  it "should flash an error" do

    application_1 = Application.create!(name: "Mary Tanaka",
                                        street_address: "123 Kapiolani Blvd.",
                                        city: "Honolulu",
                                        state: "HI",
                                        zip_code: "98684",
                                        description: "I'm a pet lover!", application_status: "In progress"
                                        )

    visit "/applications/#{application_1.id}"

    application_1.update_status("Pending")

    fill_in 'search', with: "Mochi"
    click_on("Search")

    expect(application_1.application_status).to eq("Pending")
    expect(current_path).to eq("/applications/#{application_1.id}")
    expect(page).to have_content("Please submit a new application.")
  end

  it "assign a pet to an application" do
    shelter_1 = Shelter.create!(name: "Dumb Friends League",
                                rank: 2,
                                city: "Honolulu",
                                foster_program: true)

    pet_1 = shelter_1.pets.create!(name: "Mochi",
                        adoptable: true,
                        age: 2,
                        breed: "American Shorthair")
    pet_2 = shelter_1.pets.create!(name: "Mocha",
                        adoptable: true,
                        age: 3,
                        breed: "American Shorthair")

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

    expect(application_1.pets).to include(pet_1)
    expect(application_1.pets).to_not include(pet_2)
  end
end
