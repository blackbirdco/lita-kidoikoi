Gem::Specification.new do |spec|
  spec.name          = "lita-kidoikoi"
  spec.version       = "0.1.0"
  spec.authors       = ["Loic Delmaire", "Sacha Al Himdani"]
  spec.email         = ["loic.delmaire@gmail.com", "sal-himd@students.42.fr"]
  spec.description   = "A plugin for splitting bills between coworkers.
                        \"Kidoikoi\" is for \"qui doit quoi\", which means in french \"who owes what\"."
  spec.summary       = "Commands:\n
                        *split_bill*  _@debtor1_ _..._ _value_ _@creditor_\n
                        *clear_debt* _@user1_ _@user2_ \n
                        *resume_debt* _@user1_"
  spec.homepage      = "https://github.com/sal-himd/lita-kidoikoi"
  spec.license       = "Licence MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.5"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
end
