module RubyAMF
  module Exceptions
    #this cass takes a AMFException and inspects the details of the exception, returning this object back to flash as a Fault object
    class ASFault < RubyAMF::Util::VoHash

      #pass an AMFException, create new keys based on exception for the fault object
      def initialize(e)
    
        backtrace = e.backtrace || e.ebacktrace #grab the correct backtrace

        begin
          linerx = /:(\d*):/
          line = linerx.match(backtrace[0])[1] #get the numbers
        rescue Exception => e
          line = 'No backtrace was found in this exception'
        end

        begin
          methodrx = /`(\S*)\'/
          method = methodrx.match(backtrace[0])[1] #just method name
        rescue Exception => e
          method = "No method was found in this exception"
        end

        begin
          classrx = /([a-zA-Z0-9_]*)\.rb/
          classm = classrx.match(backtrace[0]) #class name
        rescue Exception => e
          classm = "No class was found in this exception"
        end

        self["code"] = e.etype.to_s #e.type.to_s
        self["description"] = e.message
        self["details"] = backtrace[0]
        self["level"] = 'UserError'
        self["class_file"] = classm.to_s
        self["line"] = line
        self["function"] = method
        self["faultString"] = e.message
        self["faultCode"] = e.etype.to_s
        self["backtrace"] = backtrace
      end
    end
  end
end