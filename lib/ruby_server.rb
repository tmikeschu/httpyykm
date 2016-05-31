require 'socket'

class RubyServer
  attr_reader :server,
              :port,
              :times_requested

  def initialize(port = 9292)
    @server = TCPServer.new(port)
    @port = port
    @times_requested = -1
  end

  def process_request
    client = server.accept
    @times_requested += 1
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    response = "<pre>" + debugger(request_lines) + "</pre>"
    body = "<html><head></head><body>Hello, World! (#{times_requested})\n\n#{response}</body></html>"
    client.puts headers(body)
    client.puts body #only if path is /hello
    client.close
  end

  def headers(output)
    headers = ['http/1.1 200 ok',
               "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
               'server: ruby',
               'content-type: text/html; charset=iso-8859-1',
               "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def keep_open
    while true
      process_request
    end
  end

  def debugger(lines)
    data = comb_and_assign_to_debugger(lines)
    format_for_request_output(data)
  end

  def comb_and_assign_to_debugger(lines)
    output = Hash.new
    lines.each do |line|
      if line.include?('HTTP')
        output[:Verb] = line[0...line.index('/')].strip
        output[:Path] = line[line.index('/')...line.index('HTTP')].strip
        output[:Protocol] = line[-8..-1]
      elsif line.include?('Host')
        output[:Host] = line.split(':')[1]
        output[:Port] = line.split(':')[2]
        output[:Origin] = `ipconfig getifaddr en0`.chomp.to_s
      end
      output[:Accept] = line.split(':')[1] if line.include?('Accept')
    end
    output
  end

  def format_for_request_output(output)
    output.to_a.map {|key, value| "#{key}: #{value}"}.join("\n")
  end

end



# #/datetime
Time.now.strftime("%I:%M%p on %A, %B %d, %Y")
