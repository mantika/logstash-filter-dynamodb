Gem::Specification.new do |s|
  s.name = 'logstash-filter-dynamodb'
  s.version         = '0.0.1'
  s.licenses = ['Apache License (2.0)']
  s.summary = ""
  s.description = ""
  s.authors = ["Mantika"]
  s.email = 'info@mantika.ca'
  s.homepage = ""
  s.require_paths = ["lib"]

  # Files
  s.files = `git ls-files`.split($\)
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "filter" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core", '>= 1.4.0', '< 2.0.0'
  s.add_development_dependency 'logstash-devutils'
end
