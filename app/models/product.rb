class Product < ApplicationRecord
  scope :index_filter, -> { where(active: true) }

  scope :by_name, ->(name) { where(name: name) }
  scope :by_name_and_by_description, ->(name, description) { where(name: name, description: description) }

  def destroy
    self.active = false
    self.save!
  end
end
