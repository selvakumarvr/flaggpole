require 'ostruct'
require 'yaml'

# Extend OpenStruct to support nested structures
class NestedOpenStruct < OpenStruct
  def initialize(hash = nil)
    @table = {}
    if hash
      for k, v in hash
        @table[k.to_sym] = v.is_a?(Hash) ? NestedOpenStruct.new(v) : v
        new_ostruct_member(k)
      end
    end
  end
end

# Load application configuration
APP_CONFIG = YAML.load(ERB.new(File.read("#{Rails.root.to_s}/config/config.yml")).result)[Rails.env]
::AppConfig = NestedOpenStruct.new(APP_CONFIG)
