require 'jumpstart_auth'

class MicroBlogger
  attr_reader :client, :followers

  def initialize
    puts "Initializing..."
    @client = JumpstartAuth.twitter
    @followers = []
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

  def everyones_last_tweet
    puts "Here are the last status messages from your follows:"
    puts " "
    friends = @client.friends.sort_by {|friend| friend.screen_name.downcase}
    friends.each do |friend|
      name = friend.screen_name
      text = friend.status.text
      timestamp = friend.status.created_at
      puts "#{name} tweeted on #{timestamp.strftime("%B %-d, %Y")}..."
      puts "  #{text}"
      puts " "
    end
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
        when 'buzz' then everyones_last_tweet
        else
          puts "Sorry, I don't know how to #{command}"
      end

    end
  end
end

blogger = MicroBlogger.new
blogger.run
