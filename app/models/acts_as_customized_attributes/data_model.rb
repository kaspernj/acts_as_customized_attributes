class ActsAsCustomizedAttributes::DataModel < ActiveRecord::Base
  belongs_to :resource, polymorphic: true

  validates_presence_of :key
end
