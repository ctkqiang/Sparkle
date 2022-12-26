require 'socket'

class Keylogger 
    def initialize 
        @@server = TCPServer.new 80
    end
    
    def start_server()
        while session = @@server.accept
            request = session.gets
            puts request
            
            session.print "HTTP/1.1 200\r\n" 
            session.print "Content-Type: text/html\r\n"
            session.print "\r\n"
            session.print "Hello world! The time is #{Time.now}"
            
            session.close
        end
    end
end

