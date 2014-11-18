[![Build Status](https://api.shippable.com/projects/546b3f7bd46935d5fbbde6b9/badge?branchName=master)](https://app.shippable.com/projects/546b3f7bd46935d5fbbde6b9/builds/latest)
[![Code Climate](https://codeclimate.com/github/kaspernj/acts_as_customized_attributes/badges/gpa.svg)](https://codeclimate.com/github/kaspernj/acts_as_customized_attributes)
[![Test Coverage](https://codeclimate.com/github/kaspernj/acts_as_customized_attributes/badges/coverage.svg)](https://codeclimate.com/github/kaspernj/acts_as_customized_attributes)

# ActsAsCustomizedAttributes

This project rocks and uses MIT-LICENSE.

## Install

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

```ruby
class AddCustomizedAttributesForSomeModel < ActiveRecord::Migration
  def up
    SomeModel.create_cuostmized_attributes!
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
