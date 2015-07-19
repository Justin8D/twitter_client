require 'jumpstart_auth'

class MicroBlogger
	attr_accessor :client

	def initialize
		puts 'initializing MicroBlogger'
		@client = JumpstartAuth.twitter
	end

	def run
		puts "Welcome to the JSl Twitter Client"
		command = ""
		while command != "q"
			printf "Enter command: "
			input = gets.chomp
			parts = input.split(" ")
			command = parts[0]
			case command
				when 'q' then puts 'Goodbye!'
				when 't' then tweet(parts[1..-1].join(" "))
				when 'dm' then dm(parts[1], parts[2..-1].join(" "))
				when 'spam' then spam_my_followers(parts[1..-1].join" ")
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

end

blogger = MicroBlogger.new
blogger.run