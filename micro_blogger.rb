require 'jumpstart_auth'
require 'bitly'
require 'klout'

Bitly.use_api_version_3


class MicroBlogger
  attr_reader :client, :followers

  def initialize
    puts "Initializing..."
    @client = JumpstartAuth.twitter
    @followers = []
    getfollowers
    Klout.api_key = 'xu9ztgnacmjx3bu82warbr3h'

  end

  def getfollowers
    @followers = @client.followers.collect{|follower| follower.screen_name}
  end

  def shorten(url)
    bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
    return bitly.shorten(url).short_url
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

  def klout_score
    friends = @client.friends.collect{|f| f.screen_name}
    friends.each do |friend|
      puts "#{friend} has a Klout score of:"
      identity = Klout::Identity.find_by_screen_name(friend)
      user = Klout::User.new(identity.id)
      puts user.score.score
      puts "" 
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
        when 'turl' then tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
        when 'dm' then dm(parts[1], parts[2..-1].join(" "))
        when 'spam' then spam_my_friends(parts[1..-1].join(" "))
        when 'buzz' then everyones_last_tweet
        when 'klout' then klout_score
        else
          puts "Sorry, I don't know how to #{command}"
      end

    end
  end
end

blogger = MicroBlogger.new
blogger.run

