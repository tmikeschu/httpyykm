require 'socket'

class RubyServer
  attr_reader :server,
              :port

  def initialize(port = 9292)
    @server = TCPServer.new(port)
    @port = port
  end

  def process_request
    client = server.accept
    body = '<html><head></head><body>Hello</body></html>'
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
end
