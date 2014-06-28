require 'spec_helper'
require 'json'

require_relative 'support/helpers'

describe "basic message queue integration" do
  include Hutch::Test::IntegrationHelpers

  let(:klass) do
    Class.new do
      include Hutch::Consumer
      include Hutch::Test::MessageRecorder
      consume 'hutch.integration.test1'
      queue_name 'hutch_integration_test'
    end
  end

  before do
    connect
    clear_queue_for(klass)
  end

  let(:message_body){ {body: "value"}}

  it "receives messages when I send them" do
    Hutch.publish('hutch.integration.test1', message_body)
    run_cli
    expect(klass.last_message.body).to eq(message_body)
  end

  it "has the correct routing key" do
    Hutch.publish('hutch.integration.test1', message_body)
    run_cli
    expect(klass.last_message.routing_key).to eq("hutch.integration.test1")
  end

end
