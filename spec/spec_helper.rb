# Prereqs
require 'yaml'

# Dependencies
require 'roo'
require 'active_record'

# Require test-related only gems
require 'factory_girl'
require 'database_cleaner'

# Our lib
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'ts_props'

#
# SETUP DB
#

specs_root     = File.dirname(__FILE__)
db_config_path = specs_root + '/db/database.yml'
db_config      = YAML.load_file(db_config_path)

ActiveRecord::Base.configurations = db_config
ActiveRecord::Base.establish_connection(:test)

#
# RSPEC CONFIG
#

RSpec.configure do |config|

  # FILTERING

  config.run_all_when_everything_filtered = true

  if ENV['SPEC_ALL']
    config.inclusion_filter = nil
  end

  # MODULES

  config.include FactoryGirl::Syntax::Methods

  # HOOKS

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation # force cleanup before any spec run

    FactoryGirl.reload
  end
end

#
# TEST MODELS
#

class Form < ActiveRecord::Base
  has_many :fields, class_name: 'FormField'
  has_many :entries, class_name: 'FormEntry'

  scope :with_fields, -> { joins(:fields).includes(:fields) }
  scope :by_position, -> { order('position ASC') }
end

class FormField < ActiveRecord::Base
  belongs_to :form
end

class FormEntry < ActiveRecord::Base
  belongs_to :form
end
