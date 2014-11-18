class ActsAsCustomizedAttributes::DataKey < ActiveRecord::Base
  validates_presence_of :name
end
