require "tty-prompt"
require 'optparse'
require_relative "./tools/phishing.rb"
require_relative "./tools/ddos_slowloris.rb"

class Sparkle
    def initialize
        @@socket_counts = 999
        @@choice = ["Local Network Phishing attack", "DDOS Slowloris attack"]
        @@options = {}
        @@prompt = TTY::Prompt.new
    end    

    def menu()
        OptionParser.new do |parser|    
            parser.banner = "Usage: ruby run.rb [arguements]\n"

            parser.on("-p",  "--phishing", @@choice[0]) do
                Phishing.new().start_server()
            end

            parser.on("-s",  "--stenography", "Stenography") do
            end

            if ARGV[0] 
                $url = ARGV[1] 
            end

            parser.on("-d", "--ddos [url] or [ipaddr]", @@choice[1]) do
                Slowloris.new(target=$url, socket_number=@@socket_counts).attack()
            end
        end.parse!  
    end
end