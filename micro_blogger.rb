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
      printf "enter command:"
      command = gets.chomp
    end
  end
end

blogger = MicroBlogger.new
blogger.run
