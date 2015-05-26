$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'ts_props'

Bundler.require(:default, :test)

RSpec.configure do |config|

  # FILTERING

  config.run_all_when_everything_filtered = true

  if ENV['SPEC_ALL']
    config.inclusion_filter = nil
  end

  # MODULES

end
