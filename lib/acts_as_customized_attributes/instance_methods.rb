# frozen_string_literal: true
module ActsAsCustomizedAttributes::InstanceMethods
  def update_customized_attributes(data)
    update_customized_attributes_with_args(data: data)
  end

  UPDATE_CUSTOMIZED_ATTRIBUTES_VALID_ARGS = [:data, :transactioner].freeze
  def update_customized_attributes_with_args(args)
    args.each { |key, _value| raise "Invalid argument: '#{key}'." unless UPDATE_CUSTOMIZED_ATTRIBUTES_VALID_ARGS.include?(key) }

    args.fetch(:data).each do |key, value|
      begin
        key_id = self.class.aaca_key_class.id_for_name(key)
      rescue KeyError
        key_model = self.class.aaca_key_class.create!(name: key)
        key_id = key_model.id
      end

      data_model = data.where(data_key_id: key_id).first
      if data_model
        data_model.resource = self # Saves query when validating.
      else
        # Set resource in order to skip query when validating.
        data_model = data.new(data_key_id: key_id, resource: self)
      end

      data_model.value = value

      if args[:transactioner]
        args[:transactioner].save!(data_model)
      else
        data_model.save!
      end
    end
  end

  def customized_attribute(name)
    self.class.aaca_data_class
      .joins(:data_key)
      .where(self.class.aaca_key_class.table_name => {name: name}, resource: self)
      .first
      .try(:value)
  end

  def customized_attributes
    attributes_hash = {}
    data.each do |data_i|
      key_name = self.class.aaca_key_class.name_for_id(data_i.data_key_id)
      attributes_hash[key_name.to_sym] = data_i.value
    end

    attributes_hash
  end
end
