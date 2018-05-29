# Load the Rails application.
require_relative 'application'

# Load the General settings before the environments
SETTINGS = YAML.load(ERB.new(File.read("#{Rails.root}/config/settings.yml")).result)[Rails.env]

# Initialize the Rails application.
Rails.application.initialize!
