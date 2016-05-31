require 'socket'

class RubyServer
  attr_reader :server,
              :port,
              :times_requested

  def initialize(port = 9292)
    @server = TCPServer.new(port)
    @port = port
    @times_requested = 0
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
    client.puts body
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
    output = Hash.new
    lines.each do |line|
      if line.include?('GET') || line.include?('POST')
        output[:Verb] = line[0..3].strip
        output[:Path] = line[line.index('/')...line.index('HTTP')].strip
        output[:Protocol] = line[-8..-1]
      elsif line.include?('Host')
        output[:Host] = line.split(':')[1]
        output[:Port] = line.split(':')[2]
        output[:Origin] = line.split(':')[1]
      end
      output[:Accept] = line.split(':')[1] if line.include?('Accept')
    end
    output.to_a.map {|key, value| "#{key}: #{value}"}.join("\n")
  end

end
