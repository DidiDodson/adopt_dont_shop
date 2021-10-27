class Admin < ApplicationRecord
  has_many :shelters
  # has_many :applications

  def self.s_query
    Shelter.find_by_sql("SELECT s.name from shelters s ORDER BY s.name DESC")
  end
end
