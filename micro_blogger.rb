require 'jumpstart_auth'

class MicroBlogger
	attr_accessor :client

	def initialize
		puts 'initializing MicroBlogger'
		@client = JumpstartAuth.twitter
	end

	def run
		puts "Welcome to the JSl Twitter Client"
	end

	def tweet(message)
		if message.length <= 140
			@client.update(message)
		else
			puts "Tweet must be not exceed 140 characters."
		end
	end

end

blogger = MicroBlogger.new
blogger.tweet("".ljust(140, "test"))