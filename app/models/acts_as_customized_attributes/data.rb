class ActsAsCustomizedAttributes::Data < ActiveRecord::Base
  validate :associated_resource_and_data_key

  def self.key_class=(key_class)
    @key_class = key_class
  end

  def self.key_class
    return @key_class
  end

private

  def associated_resource_and_data_key
    unless data_key_id?
      return errors.add :data_key_id, "not valid"
    end

    if !resource_id? || !resource
      return errors.add :resource_id, "not associated"
    end

    begin
      self.class.key_class.name_for_id(data_key_id)
    rescue KeyError
      errors.add :data_key_id, "doesn't exist"
    end
  end
end
