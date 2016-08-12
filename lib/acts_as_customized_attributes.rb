# frozen_string_literal: true
require "acts_as_customized_attributes/engine"

module ActsAsCustomizedAttributes
  extend ActiveSupport::Autoload

  autoload :InstanceMethods
  autoload :ClassMethods
  autoload :Compatibility
end

ActiveSupport.on_load(:active_record) do
  include ActsAsCustomizedAttributes::Compatibility
end
