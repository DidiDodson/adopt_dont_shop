class Application < ApplicationRecord
  has_many :pets_applications
  has_many :pets, through: :pets_applications

  validates :name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true, numericality: true
  validates :description, presence: true

  def update_status(status)
    self.update_attribute(:application_status, status)
  end

  def app_status
    self.application_status = "In Progress" unless self.application_status == "Pending" || self.application_status == "Accepted" || self.application_status == "Rejected"
  end

  # def add_pet(pet)
  #   self.pets << pet
  # end
end
