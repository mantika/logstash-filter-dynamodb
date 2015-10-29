require 'spec_helper'
require "logstash/filters/dynamodb"

describe LogStash::Filters::DynamoDB do
  describe "Check convertions" do
    let(:config) do <<-CONFIG
      filter {
        dynamodb { }
      }
    CONFIG
    end

    sample('message' => '{"eventID":"0","eventName":"INSERT","eventVersion":"1.0","eventSource":"aws:dynamodb","awsRegion":{},"dynamodb":{"keys":{"id":{"S":"809c2aad-bdb1-43a4-8f67-d56589e4058d"}},"newImage":{"criterias":{"SS":["a","b"]},"id":{"S":"809c2aad-bdb1-43a4-8f67-d56589e4058d"},"labels":{"M":{"foo":{"S":"bar"}}}}}}') do


      expect(subject).to include("eventName")
      expect(subject['eventName']).to eq('INSERT')

      expect(subject).to include("keys")
      expect(subject['keys']).to eq({'id' => '809c2aad-bdb1-43a4-8f67-d56589e4058d'})

      expect(subject).to include("id")
      expect(subject['id']).to eq('809c2aad-bdb1-43a4-8f67-d56589e4058d')

      expect(subject).to include("criterias")
      expect(subject['criterias']).to eq(['a', 'b'])

      expect(subject).to include("labels")
      expect(subject['labels']).to eq({'foo' => 'bar'})
    end

    sample('message' => '{"eventID":"0","eventName":"REMOVE","eventVersion":"1.0","eventSource":"aws:dynamodb","awsRegion":{},"dynamodb":{"keys":{"id":{"S":"809c2aad-bdb1-43a4-8f67-d56589e4058d"}}}}') do
      expect(subject).to include("eventName")
      expect(subject['eventName']).to eq('REMOVE')

      expect(subject).to include("keys")
      expect(subject['keys']).to eq({'id' => '809c2aad-bdb1-43a4-8f67-d56589e4058d'})
    end
  end
end
