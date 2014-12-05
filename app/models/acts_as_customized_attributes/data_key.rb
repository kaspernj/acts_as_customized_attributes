class ActsAsCustomizedAttributes::DataKey < ActiveRecord::Base
  after_create :add_to_cache
  after_update :add_to_cache
  after_destroy :remove_from_cache
  before_update :remove_from_cache

  validates_presence_of :name
  validate :validate_unique_name

  def self.id_for_name(name)
    cache_name_to_id.fetch(name.to_s)
  end

  def self.name_for_id(id)
    cache_name_to_id.key(id) or raise KeyError, "No such ID: #{id}"
  end

  def self.cache_name_to_id
    update_cache_name_to_id unless @cache_name_to_id
    return @cache_name_to_id
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
    begin
      id_exists = self.class.id_for_name(name)

      if id_exists != id
        errors.add :name, :taken
      end
    rescue KeyError
      # No problem.
    end
  end
end
