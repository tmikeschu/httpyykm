require 'minitest/autorun'
require 'minitest/pride'
require './lib/parse_and_format'

class ParseAndFormatTest < Minitest::Test
  include ParseAndFormat

  def test_it_can_format_request_lines_for_debugger
    lines = ["GET / HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive",
             "Cache-Control: no-cache", "User-Agent: Mozilla/5.0",
             "Postman-Token: 602c9eaf-23a7-276a-f55b-59f1cf0ee4c2",
             "Accept: */*, Accept-Encoding: gzip, deflate, Accept-Language: en-US"]
    result = "Verb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: #{`ipconfig getifaddr en0`.chomp.to_s}\nAccept: */*, Accept-Encoding"
    assert_equal result, debugger(lines)
  end

  def test_it_loads_the_dictionary_file #let's discuss this test tomorrow
    skip
    assert_equal "a", dictionary[0]
    assert_equal "abandon", dictionary[45]
  end

end
