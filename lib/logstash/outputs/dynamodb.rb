# encoding: utf-8
require "logstash/outputs/base"
require "logstash/namespace"
require "aws-sdk-core"
require "yaml"
require "securerandom"

# An example output that does nothing.
class LogStash::Outputs::DynamoDB < LogStash::Outputs::Base
  config_name "dynamodb"
  config :credentials_file, :validate => :string, :required => false
  config :table_name, :validate => :string, :required => true
  config :region, :validate => :string, :required => true
  config :fields, :validate => :array, :required => true
  config :id_field, :validate => :string, :required => true
  config :sort_field, :validate => :string, :required => false
  config :make_sort_unique, :required => false

  @dynamodb = nil

  public
  def register
    # load credentials from disk
    if @credentials_file
      puts "Reading credentials from " + @credentials_file
      creds = YAML.load(File.read(@credentials_file))
      Aws.config[:credentials] = Aws::Credentials.new(creds['access_key_id'],creds['secret_access_key'])
    end
    puts "Setting region " + @region
    Aws.config[:region] = @region
    puts "Creating DynamoDB client"
    @dynamodb = Aws::DynamoDB::Client.new
    begin
      # check if dynamodb table exists
      puts "Checking for table " + @table_name
      @dynamodb.describe_table(:table_name => @table_name)
    rescue
      # create table if it does not exist
      puts "Table not found, creating table " + @table_name
      attribute_definitions = [
          {
            :attribute_name => @id_field,
            :attribute_type => :S
          }
        ]
      key_schema = [
          {
            :attribute_name =>  @id_field,
            :key_type => :HASH
          }
        ]
      if  @sort_field
        attribute_definitions << { :attribute_name => @sort_field, :attribute_type => :S }
        key_schema << { :attribute_name =>  @sort_field, :key_type => :RANGE }
      end

      @dynamodb.create_table(
          :table_name => @table_name,
          :attribute_definitions => attribute_definitions,
          :key_schema => key_schema,
          :provisioned_throughput => {
            :read_capacity_units => 2,
            :write_capacity_units => 50,
          }
        )
      @dynamodb.wait_until(:table_exists, table_name: @table_name)
    end
  end # def register

  public
  def receive(event)
      message = Hash.new
      message[@id_field] = event[@id_field]

      if @sort_field
        if @make_sort_unique
          message[@sort_field] = event[@sort_field].to_s + "_" + SecureRandom.urlsafe_base64
        else
          message[@sort_field] = event[@sort_field].to_s
        end
      end

      @fields.each do |x|
        if event[x]
          message[x] = event[x].to_s
        end
      end
      @dynamodb.put_item(:table_name => @table_name, :item => message)
  end # def event
end # class LogStash::Outputs::Example
