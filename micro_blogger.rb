require 'jumpstart_auth'

class MicroBlogger
  attr_reader :client, :followers

  def initialize
    puts "Initializing..."
    @client = JumpstartAuth.twitter
    getfollowers
  end

  def getfollowers
    @followers = @client.followers.collect{|follower| follower.screen_name}
  end

  def tweet(message)
    @client.update(message)
  end

  def dm(target, message)
    puts "Trying to send #{target} this direct message:"
    puts message
    if @followers.include?(target)
      tweet("d #{target} #{message}")
    else
      puts "Direct messages can only be sent to your followers. Please try again."
    end
  end

  def spam_my_friends(message)
    @followers.each {|follower| dm(follower, message)}
  end

  def run
    puts "Welcome to the TinMan Twitter Client!"
    command = ""
    while command != "q"
      printf "enter command: "
      input = gets.chomp
      parts = input.split(" ")
      command = parts[0]
      case command
        when 'q' then puts "Goodbye!"
        when 't' then tweet(parts[1..-1].join(" "))
        when 'dm' then dm(parts[1], parts[2..-1].join(" "))
        when 'spam' then spam_my_friends(parts[1..-1].join(" "))
        else
          puts "Sorry, I don't know how to #{command}"
      end

    end
  end
end

blogger = MicroBlogger.new
blogger.run
