require 'rails_helper'

RSpec.describe "the Application show page" do
  before(:each) do
    @shelter_1 = Shelter.create!(name: "Dumb Friends League",
                                rank: 2,
                                city: "Honolulu",
                                foster_program: true)

    @pet_1 = @shelter_1.pets.create!(name: "Mochi",
                        adoptable: true,
                        age: 2,
                        breed: "American Shorthair")
    @pet_2 = @shelter_1.pets.create!(name: "Dango",
                        adoptable: true,
                        age: 4,
                        breed: "Bengal")
    @pet_3 = @shelter_1.pets.create!(name: "Mocha",
                        adoptable: true,
                        age: 7,
                        breed: "Bombay")

    @application_1 = Application.create!(name: "Mary Tanaka",
                                        street_address: "123 Kapiolani Blvd.",
                                        city: "Honolulu",
                                        state: "HI",
                                        zip_code: "98684")
  end

  it "should display an application" do
    @application_1.pets << @pet_1
    @application_1.pets << @pet_2

    visit "/applications/#{@application_1.id}"

    expect(page).to have_content(@application_1.name)
    expect(page).to have_content(@application_1.street_address)
  end

  it "should return a pet after name search" do
    visit "/applications/#{@application_1.id}"

    expect(page).to have_content("Add a Pet to this Application")

    fill_in 'search', with: "Mochi"
    click_on("Search")

    expect(page).to have_content(@pet_1.name)
  end

  it "should return multiple pets with partial search term" do
    visit "/applications/#{@application_1.id}"

    expect(page).to have_content("Add a Pet to this Application")

    fill_in 'search', with: "Moch"
    click_on("Search")

    expect(page).to have_content(@pet_1.name)
    expect(page).to have_content(@pet_3.name)
  end

  it "should show a link to adopt" do
    visit "/applications/#{@application_1.id}"

    fill_in 'search', with: "Moch"
    click_on("Search")

    expect(page).to have_link("Adopt this Pet")
  end

  it "assigns a pet to an application" do
    visit "/applications/#{@application_1.id}"

    fill_in 'search', with: "Moch"
    click_on("Search")

    within("#application_1-#{@pet_1.id}") do
      expect(page).to have_content(@pet_1.name)
      expect(page).to have_link("Adopt this Pet")
      click_on("Adopt this Pet")
    end

    expect(@application_1.pets).to include(@pet_1)
    expect(@application_1.pets).to_not include(@pet_2)
  end

  it "includes submit section" do
    visit "/applications/#{@application_1.id}"

    fill_in 'search', with: "Moch"
    click_on("Search")

    expect(page).to_not have_content("Submit My Application")

    within("#application_1-#{@pet_1.id}") do
      click_on("Adopt this Pet")
    end

    expect(page).to have_content("Submit My Application")
    expect(page).to have_content("Why would I be a great pet parent:")

    fill_in "description", with: "I love Cats!"
    click_button "Submit"

    expect(current_path).to eq("/applications/#{@application_1.id}")
    expect(@application_1.reload.application_status).to eq("Pending")
    expect(@application_1.reload.description).to eq("I love Cats!")
  end

  it "after submitting add pet is gone" do
    visit "/applications/#{@application_1.id}"

    fill_in 'search', with: "Moch"
    click_on("Search")

    within("#application_1-#{@pet_1.id}") do
      click_on("Adopt this Pet")
    end

    expect(page).to have_content("Submit My Application")
    expect(page).to have_content("Why would I be a great pet parent:")

    fill_in "description", with: "I love Cats!"
    click_button "Submit"

    expect(page).to_not have_content("Add a Pet to this Application")
  end
end
