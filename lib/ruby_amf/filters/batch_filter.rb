module RubyAMF
  module Filters

    class BatchFilter
      include RubyAMF::App
      include RubyAMF::Exceptions
      def run(amfobj)
        body_count = amfobj.num_body
        0.upto(body_count - 1) do |i| #loop through all bodies, do each action on the body
          body = amfobj.get_body_at(i)
          RequestStore.actions.each do |action|
            begin #this is where any exception throughout the RubyAMF Process gets transformed into a relevant AMF0/AMF3 faultObject
              action.run(body)
              # puts "#{action} took: " + Benchmark.realtime{action.run(body)}.to_s + " secs"
            rescue RubyAMF::Exceptions::AMFException => ramfe
              puts ramfe.message
              puts ramfe.backtrace
              ramfe.ebacktrace = ramfe.backtrace.to_s
              RubyAMF::Exceptions::ExceptionHandler::HandleException(ramfe,body)
            rescue Exception => e
              puts e.message
              puts e.backtrace
              ramfe = RubyAMF::Exceptions::AMFException.new(e.class.to_s, e.message.to_s) #translate the exception into a rubyamf exception
              ramfe.ebacktrace = e.backtrace.to_s
              RubyAMF::Exceptions::ExceptionHandler::HandleException(ramfe, body)
            end
          end
        end
      end
    end
  end
end