# frozen_string_literal: true
module ActsAsCustomizedAttributes::Compatibility
  def self.included(base)
    base.extend ActsAsCustomizedAttributes::ClassMethods
  end
end
