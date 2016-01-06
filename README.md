[![Code Climate](https://codeclimate.com/github/kaspernj/acts_as_customized_attributes/badges/gpa.svg)](https://codeclimate.com/github/kaspernj/acts_as_customized_attributes)
[![Test Coverage](https://codeclimate.com/github/kaspernj/acts_as_customized_attributes/badges/coverage.svg)](https://codeclimate.com/github/kaspernj/acts_as_customized_attributes)
[![Build Status](https://img.shields.io/shippable/546b3f7bd46935d5fbbde6b9.svg)](https://app.shippable.com/projects/546b3f7bd46935d5fbbde6b9/builds/latest)

# ActsAsCustomizedAttributes

Add custom attributes to your models, which doesn't have predefined names but can be created runtime, and still be able to do queries on that data.


## Install

### Bundle

Add this to your Gemfile and bundle:
```ruby
gem 'acts_as_customized_attributes'
```

### Modify model

```ruby
class SomeModel
  acts_as_customized_attributes
end
```

### Create a migration

This creates the tables "some_model_data_keys" and "some_model_data", where the custom attributes will be stored.

```ruby
class AddCustomizedAttributesForSomeModel < ActiveRecord::Migration
  def up
    SomeModel.create_customized_attributes!
  end

  def down
    SomeModel.drop_customized_attributes!
  end
end
```

## Usage

### Set customized attributes for a model.

```ruby
some_model.update_customized_attributes(my_custom_attribute: 5)
```

### Get all custom attributes for a model.

```ruby
some_model.customized_attributes #=> {:my_custom_attribute => 5}
```

### Queries

#### Query keys.

```ruby
SomeModel::DataKey.where("name LIKE '%facebook%'")
```

### Query data

```ruby
SomeModel::Data.where("resource_id > 5")
```

### Optimize inserts with transactions for inserts / updates.
```ruby
ActiveRecordTransactioner.new do |trans|
  models.each do |model|
    model.update_customized_attributes_with_args(data: {my_custom_attribute: 5}, transactioner: trans)
  end
end
```

## License

This project uses MIT-LICENSE.
