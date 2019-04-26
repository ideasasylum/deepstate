require 'simplecov'
SimpleCov.start

require "bundler/setup"
require "pry"

require "deep_state"

# Make our examples available to tests
examples = File.expand_path("../../examples", __FILE__)
$LOAD_PATH.unshift(examples) unless $LOAD_PATH.include?(examples)


RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
