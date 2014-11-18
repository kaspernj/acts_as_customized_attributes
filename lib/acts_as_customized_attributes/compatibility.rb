module ActsAsCustomizedAttributes::Compatibility
  def acts_as_customized_attributes(args = {})
  end

  def create_customized_data!
    migration_class.new.migrate(:up)
  end

  def drop_customized_data!
    migration_class.new.migrate(:down)
  end

private

  def migration_class
    $acts_as_customized_attributes_keys_table_name = "#{name_tableize}_data_keys"
    $acts_as_customized_attributes_table_name = "#{name.tableize}_data"

    clazz = Class.new ActiveRecord::Migration do
      def up
        create_table $acts_as_customized_attributes_keys_table_name do |t|
          t.string :data_key
          t.string :title
          t.timestamps
        end

        create_table $acts_as_customized_attributes_table_name do |t|
          t.belongs_to :resource, polymorphic: true
          t.string :data_key
          t.string :value
          t.timestamps
        end

        add_index $acts_as_customized_attributes_table_name, :key
      end

      def down
        drop_table $acts_as_customized_attributes_table_name
      end
    end
  end
end
