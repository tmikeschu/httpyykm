require './lib/ruby_server.rb'

puts 'Server is up and running! Play around at http://127.0.0.1:9292'
my_server = RubyServer.new
my_server.keep_open
