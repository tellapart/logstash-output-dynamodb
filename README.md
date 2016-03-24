# Logstash DynamoDB Output Plugin

[![Build
Status](http://build-eu-00.elastic.co/view/LS%20Plugins/view/LS%20Outputs/job/logstash-plugin-output-example-unit/badge/icon)](http://build-eu-00.elastic.co/view/LS%20Plugins/view/LS%20Outputs/job/logstash-plugin-output-example-unit/)

This is a plugin for [Logstash](https://github.com/elastic/logstash).

It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way.

## Documentation

Logstash provides infrastructure to automatically generate documentation for this plugin. We use the asciidoc format to write documentation so any comments in the source code will be first converted into asciidoc and then into html. All plugin documentation are placed under one [central location](http://www.elastic.co/guide/en/logstash/current/).

- For formatting code or config example, you can use the asciidoc `[source,ruby]` directive
- For more asciidoc formatting tips, see the excellent reference here https://github.com/elastic/docs#asciidoc-guide

## Need Help?

Need help? Try #logstash on freenode IRC or the https://discuss.elastic.co/c/logstash discussion forum.

## Developing

### 1. Plugin Developement and Testing

#### Code
- To get started, you'll need JRuby with the Bundler gem installed.

- Create a new plugin or clone and existing from the GitHub [logstash-plugins](https://github.com/logstash-plugins) organization. We also provide [example plugins](https://github.com/logstash-plugins?query=example).

- Install dependencies
```sh
bundle install
```

#### Test

- Update your dependencies

```sh
bundle install
```

- Run tests

```sh
bundle exec rspec
```

### 2. Running your unpublished Plugin in Logstash

#### 2.1 Example configuration

- Create a YAML file with your AWS credentials:
```yaml
---
access_key_id: <key_id>
secret_access_key: <secret>
```

- Add the dynamodb section to your logstash configuration
```ruby
output {
  dynamodb {
    credentials_file => "<file with your AWS creds>"
    table_name => "<dynamodb table>"    # table will be created automatically
    region => "us-east-1"               # your AWS region
    fields => ["message"]               # the fields you want to send to DynamoDB
    id_field => "host"                  # DynamoDB Hash key
    sort_field => "@timestamp"          # DynamoDB Range key
    make_sort_unique => true            # Will append a unique string to the
                                        # sort_field to avoid collisions
  }
}
```

#### 2.2 Run in an installed Logstash

- Build your plugin gem
```sh
gem build logstash-output-dynamodb.gemspec
```
- Install the plugin from the Logstash home
```sh
bin/plugin install /your/local/plugin/logstash-output-dynamodb-0.0.1.gem
```
- Start Logstash and proceed to test the plugin

#### 3 Package into RPM

- You can build an rpm using fpm that installs the plugin in logstash, run:
```sh
make all
```

## Contributing

All contributions are welcome: ideas, patches, documentation, bug reports, complaints, and even something you drew up on a napkin.

Programming is not a required skill. Whatever you've seen about open source and maintainers or community members  saying "send patches or die" - you will not see that here.

It is more important to the community that you are able to contribute.

For more information about contributing, see the [CONTRIBUTING](https://github.com/elastic/logstash/blob/master/CONTRIBUTING.md) file.
