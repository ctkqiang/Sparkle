require "tty-prompt"
require 'optparse'
require_relative "./tools/phishing.rb"

class Sparkle
    def initialize
        @@choice = ["Generate phishing url"]
        @@options = {}
        @@prompt = TTY::Prompt.new
    end    

    def menu()
        # parser = OptionParser.new do |parser|     
        #     parser.on("-k",  "--Phishing", "Activate Phishing") do
        #         puts "Phishing" 
        #     end
        #     parser.on("-s",  "--stenography", "Stenography") do 
        #     end
        # end
        # parser.parse!(into: @@options)

        menu = @@prompt.select("Please select a tool", @@choice)

        if menu == @@choice[0]
            # TODO add Phishing 
            Phishing.new().start_server()
        end
    end
end
