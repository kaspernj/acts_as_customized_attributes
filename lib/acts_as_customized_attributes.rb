require "acts_as_customized_attributes/engine"

module ActsAsCustomizedAttributes
  extend ActiveSupport::Autoload

  autoload :Compatibility
end

ActiveSupport.on_load(:active_record) do
  extend ActsAsCustomizedAttributes::Compatibility
end
