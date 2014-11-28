module ActsAsCustomizedAttributes::InstanceMethods
  def update_customized_attributes(data)
    data.each do |key, value|
      key = self.class.aaca_key_class.find_or_create_by_name(key)

      data = self.class.aaca_data_class.find_or_initialize_by_data_key_id_and_resource_id(key.id, id)
      data.value = value
      data.save!
    end
  end

  def customized_attributes
    hash = {}
    data.includes(:data_key).each do |data_i|
      hash[data_i.data_key.name.to_sym] = data_i.value
    end

    return hash
  end
end
