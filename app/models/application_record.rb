class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.index_filter
    raise NotImplementedError, "You must define the index_filter method"
  end
end
