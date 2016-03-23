build:
	gem build logstash-output-dynamodb.gemspec

rpm:
	fpm -d java --prefix /opt/logstash/plugins -s gem -s gem -t rpm --gem-bin-path /opt/jruby-1.7.18/bin  logstash-output-dynamodb-0.0.1.gem

install: install-package install-plugin

install-package:
	sudo yum install -y rubygem-logstash-output-dynamodb-0.0.1-1.noarch.rpm

install-plugin:
	sudo /opt/logstash/bin/plugin install /opt/logstash/plugins/cache/logstash-output-dynamodb-0.0.1.gem

clean:
	rm *.gem *.rpm
