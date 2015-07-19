require 'jumpstart_auth'

class MicroBlogger
	attr_accessor :client

	def initialize
		puts "initializing MicroBlogger\n\n"
		@client = JumpstartAuth.twitter
	end

	def run
		puts "Welcome to the JSl Twitter Client\n\n"
		command = ""
		while command != "q"
			printf "Enter command. (Type 'h' for a list of commands):  "
			input = gets.chomp
			parts = input.split(" ")
			command = parts[0]
			case command
				when 'q' then puts 'Goodbye!'
				when 't' then tweet(parts[1..-1].join(" "))
				when 'dm' then dm(parts[1], parts[2..-1].join(" "))
				when 'spam' then spam_my_followers(parts[1..-1].join" ")
				when 'elt' then everyones_last_tweet
				when 's' then shorten(parts[1..-1].join(" "))
				when 'tu' then tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]).to_s)
				when 'h' then puts %q{Command List:

--Message Commands--
t: Send a tweet. (Syntax: "t <tweet>")
tu: Send a tweet with a shortened URL. (Syntax: "tu <tweet> <URL>")
dm: Send a direct message. (Syntax: "dm <user name> <message>")
spam: Send a direct message to all your followers. (Syntax: "spam <message>")

--Other Commands--
s: Shorten a URL. (Syntax: "s <URL>")
elt: See your friends' latest tweets. (Syntax "elt")
h: Access this menu.
q: Quit.
}
				else puts "Sorry, '#{command}' is not a valid command."
			end
		end
	end

	def tweet(message)
		if message.length <= 140
			@client.update(message)
		else
			puts "Tweet must be not exceed 140 characters."
		end
	end

	def dm(target, message)
		puts "Sending this Direct Message to #{target}: "
		puts message
		screen_names = 	@client.followers.collect {|follower| @client.user(follower).screen_name}
		screen_names.map!(&:downcase)
		target.downcase!
		if screen_names.include?(target)
			message = "d @#{target} #{message}"
			tweet(message)
		else
			puts "Sorry. You may only send Direct Messages to your followers."
		end
	end

	def followers_list
    	screen_names = []
    	@client.followers.each {|follower| screen_names << @client.user(follower).screen_name}
    	screen_names.map!(&:downcase)
  	end

  	def spam_my_followers(message)
    	followers_list.each { |follower| dm(follower, message)}
  	end

  	def everyones_last_tweet
  		@client.friends.each {|friend| 
  			timestamp = @client.user(friend).status.created_at
  			puts "@#{@client.user(friend).screen_name} (#{timestamp.strftime('%A, %b %d')}): #{@client.user(friend).status.text} \n"
  			}
  	end

  	def shorten(original_url)
  		puts "Shortening this URL: #{original_url}"
		require 'bitly'
		Bitly.use_api_version_3
		bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
		return bitly.shorten(original_url).short_url
  	end

end

blogger = MicroBlogger.new
blogger.run