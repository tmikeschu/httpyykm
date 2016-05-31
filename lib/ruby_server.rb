require 'socket'

class RubyServer
  attr_reader :server,
              :port,
              :hello_requests,
              :all_requests

  def initialize(port = 9292)
    @server = TCPServer.new(port)
    @port = port
    @hello_requests = -1
    @all_requests = 0
  end

  def process_request
    client = server.accept
    @all_requests += 1
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    if requested_path(request_lines) == '/'
      response = "<pre>" + debugger(request_lines) + "</pre>"
    elsif requested_path(request_lines) == '/hello'
      @hello_requests += 1
      response = "Hello, World! (#{hello_requests})"
    elsif requested_path(request_lines) == '/datetime'
      response = Time.now.strftime("%I:%M%p on %A, %B %d, %Y")
    elsif requested_path(request_lines)[0..11] == '/word_search'
      response = word_search
    elsif requested_path(request_lines) == '/shutdown'
      response = "Total Requests: #{all_requests}"
      server.close
    end
    body = "<html><head></head><body>#{response}</body></html>"
    client.puts headers(body)
    client.puts body
    client.close
  end

  def word_search
    dictionary = File.readlines("/usr/share/dict/words")
    formatted_dictionary = dictionary.map { |word| word.downcase.rstrip }
    p formatted_dictionary[0]
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
        output[:Host] = line.split(':')[1].strip
        output[:Port] = line.split(':')[2]
        output[:Origin] = `ipconfig getifaddr en0`.chomp.to_s
      end
      output[:Accept] = line.split(':')[1].strip if line.include?('Accept:')
    end
    output
  end

  def format_for_request_output(output)
    output.to_a.map {|key, value| "#{key}: #{value}"}.join("\n")
  end

  def requested_path(lines)
    data = comb_and_assign_to_debugger(lines)
    data[:Path]
  end

end
