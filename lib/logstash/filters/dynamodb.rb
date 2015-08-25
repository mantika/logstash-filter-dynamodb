# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"
require 'bigdecimal'
require 'stringio'
require 'set'
require 'json'

require 'bigdecimal'
require 'stringio'
require 'set'
require 'json'


class LogStash::Filters::DynamoDB < LogStash::Filters::Base



class Unmarshaler
        def format(obj)
          type, value = extract_type_and_value(obj)
          case type.downcase
          when :m
            value.each.with_object({}) do |(k, v), map|
              map[k.to_s] = format(v)
            end
          when :l then value.map { |v| format(v) }
          when :s then value
          when :n then BigDecimal.new(value)
          when :b then StringIO.new(value)
          when :null then nil
          when :bool then value
          when :ss then Array.new(value)
          when :ns then Array.new(value.map { |n| BigDecimal.new(n) })
          when :bs then Array.new(value.map { |b| StringIO.new(b) })
          else
            raise ArgumentError, "unhandled type #{type.inspect}"
          end
        end

        def extract_type_and_value(obj)
          case obj
          when Hash then obj.to_a.first
          when Struct
            obj.members.each do |key|
              value = obj[key]
              return [key, value] unless value.nil?
            end
          else
            raise ArgumentError, "unhandled type #{obj.inspect}"
          end
        end
end




  config_name "dynamodb"
  
  #config :message, :validate => :string, :default => "Hello World!"
  
  public
  def register
    @unmarshaller = Unmarshaler.new
  end 

  public
  def filter(event)
	doc = JSON.parse(event['message'], :symbolize_names => true)

	doc[:dynamodb][:newImage].each do |key, value|
		event[key.to_s] = @unmarshaller.format(value)
	end

    filter_matched(event)
  end
end
