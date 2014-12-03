module ActsAsCustomizedAttributes::ClassMethods
  def acts_as_customized_attributes(args = {})
    $aaca_class_name_key = "#{name}DataKey"
    $aaca_class_name_data = "#{name}Data"

    class_data_key = Class.new(ActsAsCustomizedAttributes::DataKey) do
      set_table_name $aaca_class_name_key.tableize

      has_many :data, class_name: $aaca_class_name_data, foreign_key: "data_key_id", dependent: :destroy

      after_create :add_to_cache
      after_update :add_to_cache
      after_destroy :remove_from_cache
      before_update :remove_from_cache
    end

    class_data = Class.new(ActsAsCustomizedAttributes::Data) do
      set_table_name $aaca_class_name_data.tableize

      belongs_to :data_key, class_name: $aaca_class_name_key

      validates_associated :data_key
    end

    Object.const_set($aaca_class_name_key, class_data_key)
    Object.const_set($aaca_class_name_data, class_data)

    include ActsAsCustomizedAttributes::InstanceMethods

    has_many :data, class_name: "#{name}Data", foreign_key: "resource_id", dependent: :destroy

    scope :join_customized_attribute, lambda { |key|
      key_id = aaca_key_class.id_for_name(key)
      join_name = "customized_attribute_#{key}"
      joins("LEFT JOIN `#{aaca_data_class.table_name}` AS `#{join_name}` ON resource_id = `#{table_name}`.`id` AND `#{join_name}`.`data_key_id` = '#{key_id}'")
    }

    scope :where_customized_attribute, lambda { |key, value|
      join_name = "customized_attribute_#{key}"
      join_customized_attribute(key).where("`#{join_name}`.value = ?", value)
    }
  end

  def create_customized_attributes!
    migration_class.new.migrate(:up)
  end

  def drop_customized_attributes!
    migration_class.new.migrate(:down)
  end

  def aaca_key_class
    @aaca_key_class ||= Object.const_get("#{name}DataKey")
  end

  def aaca_data_class
    @aaca_data_class ||= Object.const_get("#{name}Data")
  end

private

  def migration_class
    $acts_as_customized_attributes_keys_table_name = "#{name.downcase}_data_keys"
    $acts_as_customized_attributes_table_name = "#{name.downcase}_data"

    clazz = Class.new(ActiveRecord::Migration) do
      def up
        create_table $acts_as_customized_attributes_keys_table_name do |t|
          t.string :name
          t.string :title
          t.timestamps
        end

        add_index $acts_as_customized_attributes_keys_table_name, :name, unique: true

        create_table $acts_as_customized_attributes_table_name do |t|
          t.belongs_to :resource
          t.belongs_to :data_key
          t.string :value
          t.timestamps
        end

        add_index $acts_as_customized_attributes_table_name, :data_key_id
        add_index $acts_as_customized_attributes_table_name, :resource_id
        add_index $acts_as_customized_attributes_table_name, [:data_key_id, :resource_id], unique: true
      end

      def down
        drop_table $acts_as_customized_attributes_table_name
        drop_table $acts_as_customized_attributes_keys_table_name
      end
    end
  end
end
