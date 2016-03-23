Gem::Specification.new do |s|
  s.name = 'logstash-output-dynamodb'
  s.version         = "0.0.1"
  s.licenses = ["Apache License (2.0)"]
  s.summary = "Sends logstash data to Amazon DynamoDB"
  s.description = "A simple Logstash DynamoDB output plugin. Its not intended to be used for high volume."
  s.authors = ["Twitter"]
  s.homepage = "http://www.elastic.co/guide/en/logstash/current/index.html"
  s.require_paths = ["lib"]

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "output" }

  # Gem dependencies
  s.add_runtime_dependency "aws-sdk-core"
  s.add_development_dependency "logstash-devutils"
end
