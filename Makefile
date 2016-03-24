all: build rpm

build:
	gem build logstash-output-dynamodb.gemspec

rpm:
	fpm -d logstash --no-auto-depends --prefix /opt/logstash/vendor/bundle/jruby/1.9 -s gem -s gem -t rpm --gem-bin-path /opt/logstash/vendor/jruby/bin --after-install fpm/after-install.sh --before-remove fpm/before-remove.sh logstash-output-dynamodb-0.0.1.gem

install:
	sudo yum install -y rubygem-logstash-output-dynamodb-0.0.1-1.noarch.rpm

clean:
	rm *.gem *.rpm
