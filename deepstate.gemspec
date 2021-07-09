lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "deep_state/version"

Gem::Specification.new do |spec|
  spec.name          = "deepstate"
  spec.version       = DeepState::VERSION
  spec.authors       = ["Jamie Lawrence"]
  spec.email         = ["jamie@ideasasylum.com"]

  spec.summary       = "Hierarchical state machines / state charts"
  spec.description   = "Implement hierarchical state machines / state charts in Ruby"
  spec.homepage      = "https://github.com/ideasasylum/deepstate"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.12.2"
  spec.add_development_dependency "pry-stack_explorer"
  spec.add_development_dependency "standardrb"
  spec.add_development_dependency "simplecov"
end
