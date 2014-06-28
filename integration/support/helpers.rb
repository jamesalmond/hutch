module Hutch
  module Test
    module MessageRecorder
      def self.included(base)
        base.extend(ClassMethods)
      end

      def process(message)
        self.class.record_message(message)
      end

      module ClassMethods
        def record_message(message)
          recorded_messages << message
        end

        def recorded_messages
          @@recorded_messages ||= []
        end

        def last_message
          recorded_messages.last
        end
      end
    end
  end
end

module Hutch
  module Test
    module IntegrationHelpers

      def connect
        Hutch.connect
      end

      def run_cli(argv=[])
        thread = Thread.new {
          Hutch::CLI.new.run(argv)
        }
        thread.join(1)
      end

      def clear_queue_for(consumer)
        Hutch.broker.queue(consumer.get_queue_name).purge
      end

    end
  end
end
