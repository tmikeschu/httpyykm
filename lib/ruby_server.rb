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
    response = "<pre>" + request_lines.join("\n") + "</pre>"
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
        
      output[:Verb] = line[0-4].strip if line.include?('GET') || line.include?('POST')
      output[:Path] = line[] if
      output[:Protocol] =
      output[:Host] =
      output[:Port] =
      output[:Origin] =
      output[:Accept] =
    end
    output
    # Desired:
    # Verb: POST
    # Path: /
    # Protocol: HTTP/1.1
    # Host: 127.0.0.1
    # Port: 9292
    # Origin: 127.0.0.1
    # Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
    # request_lines currently produces:
    # VERB/PATH/PROTOCOL: GET / HTTP/1.1
    # Host: 127.0.0.1:9292
    # Connection: keep-alive
    # Cache-Control: no-cache
    # User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Postman/4.2.2 Chrome/47.0.2526.73 Electron/0.36.2 Safari/537.36
    # Postman-Token: 8babde6f-141e-1616-86fd-34c9c981e9f3
    # Accept: */*
    # Accept-Encoding: gzip, deflate
    # Accept-Language: en-US

  end

end
