class EnableHstore < ActiveRecord::Migration
  def self.up
    enable_extension 'hstore' unless extension_enabled?('hstore')
  end

  def self.down
    disable_extension 'hstore' if extension_enabled?('hstore')
  end
end
