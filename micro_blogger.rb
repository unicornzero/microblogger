require 'jumpstart_auth'

class MicroBlogger
  attr_reader :client

  def initialize
    puts "Initializing..."
    @client = JumpstartAuth.twitter
  end

  def tweet(message)
    @client.update(message)
  end

  def run
    puts "Welcome to the TinMan Twitter Client!"
    command = ""
    while command != "q"
      printf "enter command: "
      input = gets.chomp
      parts = input.split(" ")
      command = parts[0]
      message = parts[1..-1].join(" ")
      case command
        when 'q' then puts "Goodbye!"
        when 't' then tweet(message)
        else
          puts "Sorry, I don't know how to #{command}"
      end

    end
  end
end

blogger = MicroBlogger.new
blogger.run
