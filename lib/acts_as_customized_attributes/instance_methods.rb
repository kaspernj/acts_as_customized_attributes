module ActsAsCustomizedAttributes::InstanceMethods
  def update_customized_attributes(data)
    data.each do |key, value|
      begin
        key_id = self.class.aaca_key_class.id_for_name(key)
      rescue KeyError
        key_model = self.class.aaca_key_class.create!(name: key)
        key_id = key_model.id
      end

      data = self.class.aaca_data_class.find_or_initialize_by_data_key_id_and_resource_id(key_id, id)
      data.value = value
      data.save!
    end
  end

  def customized_attribute(name)
    key_id = self.class.aaca_key_class.id_for_name(name)
    self.class.aaca_data_class.where(data_key_id: key_id).first.try(:value)
  end

  def customized_attributes
    hash = {}
    data.each do |data_i|
      key_name = self.class.aaca_key_class.name_for_id(data_i.data_key_id)
      hash[key_name.to_sym] = data_i.value
    end

    return hash
  end
end
