# frozen_string_literal: true
module ActsAsCustomizedAttributes::ClassMethods
  def acts_as_customized_attributes(_args = {})
    $aaca_class_name_key = "#{name}DataKey"
    $aaca_class_name_data = "#{name}Data"
    $original_class_name = name

    class_data_key = Class.new(ActiveRecord::Base) do
      if respond_to?(:set_table_name)
        set_table_name $aaca_class_name_key.tableize
      else
        self.table_name = $aaca_class_name_key.tableize
      end

      after_create :add_to_cache
      after_update :add_to_cache
      after_destroy :remove_from_cache
      before_update :remove_from_cache

      validates_presence_of :name
      validate :validate_unique_name

      has_many :data, class_name: $aaca_class_name_data.to_s, table_name: $aaca_class_name_data.tableize.to_s, foreign_key: "data_key_id", dependent: :destroy

      def self.id_for_name(name)
        cache_name_to_id.fetch(name.to_s)
      end

      def self.name_for_id(id)
        cache_name_to_id.key(id) || raise(KeyError, "No such ID: #{id}")
      end

      def self.cache_name_to_id
        update_cache_name_to_id unless @cache_name_to_id
        @cache_name_to_id
      end

      # Initializes / reloads the cache.
      def self.update_cache_name_to_id
        @cache_name_to_id = {}
        find_each do |data_key|
          @cache_name_to_id[data_key.name] = data_key.id
        end
      end

                     private

      def add_to_cache
        self.class.cache_name_to_id[name.to_s] = id
      end

      def remove_from_cache
        self.class.cache_name_to_id.delete(name_was)
      end

      def validate_unique_name
        id_exists = self.class.id_for_name(name)

        errors.add :name, :taken if id_exists != id
      rescue KeyError
        # No problem.
      end
    end

    class_data = Class.new(ActiveRecord::Base) do
      if respond_to?(:set_table_name)
        set_table_name $aaca_class_name_data.tableize
      else
        self.table_name = $aaca_class_name_data.tableize
      end

      belongs_to :resource, class_name: $original_class_name.to_s
      belongs_to :data_key, class_name: $aaca_class_name_key.to_s

      validate :associated_resource_and_data_key

      def self.key_class=(key_class)
        @key_class = key_class
      end

      def self.key_class
        @key_class
      end

                 private

      def associated_resource_and_data_key
        return errors.add :data_key_id, "not valid" unless data_key_id?

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

    Object.const_set($aaca_class_name_key, class_data_key)
    Object.const_set($aaca_class_name_data, class_data)

    class_data.key_class = Object.const_get($aaca_class_name_key)

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
    $table_name = table_name

    Class.new(ActiveRecord::Migration) do
      def up
        create_table $acts_as_customized_attributes_keys_table_name do |t|
          t.string :name
          t.string :title
          t.timestamps
        end

        add_index $acts_as_customized_attributes_keys_table_name, :name, unique: true

        create_table $acts_as_customized_attributes_table_name do |t|
          t.belongs_to :resource, index: true
          t.belongs_to :data_key, index: true
          t.string :value
          t.timestamps
        end

        add_foreign_key $acts_as_customized_attributes_table_name, $acts_as_customized_attributes_keys_table_name, column: "data_key_id", on_delete: :cascade
        add_foreign_key $acts_as_customized_attributes_table_name, $table_name, column: "resource_id", on_delete: :cascade
        add_index $acts_as_customized_attributes_table_name, [:data_key_id, :resource_id], unique: true
      end

      def down
        drop_table $acts_as_customized_attributes_table_name
        drop_table $acts_as_customized_attributes_keys_table_name
      end
    end
  end
end
