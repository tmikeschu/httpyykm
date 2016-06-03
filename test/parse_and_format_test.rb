require 'minitest/autorun'
require 'minitest/pride'
require './lib/parse_and_format'

class ParseAndFormatTest < Minitest::Test
  include ParseAndFormat

  def test_it_can_format_request_lines_for_debugger
    lines = ['GET / HTTP/1.1', 'Host: 127.0.0.1:9292', 'Connection: keep-alive',
             'Cache-Control: no-cache', 'User-Agent: Mozilla/5.0',
             'Postman-Token: 602c9eaf-23a7-276a-f55b-59f1cf0ee4c2',
             'Accept: */*, Accept-Encoding: gzip, deflate, Accept-Language: en-US']
    result = "Verb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: #{`ipconfig getifaddr en0`.chomp}\nAccept: */*, Accept-Encoding"
    assert_equal result, debugger(lines)
  end

  def test_it_can_find_a_word_in_the_dictionary
    assert_equal 'a known', word_search('test')
    assert_equal 'not a known', word_search('ahstd')
  end

  def test_it_can_comb_and_assign_values_to_a_hash
    line = ['GET / HTTP/1.1']
    result = { Verb: 'GET', Path: '/', Protocol: 'HTTP/1.1' }
    assert_equal result, comb_and_assign_to_debugger(line)
  end

  def test_it_can_format_the_hash_for_output
    hash = { Verb: 'GET', Path: '/', Protocol: 'HTTP/1.1' }
    result = "Verb: GET\nPath: /\nProtocol: HTTP/1.1"
    assert_equal result, format_for_request_output(hash)
  end

  def test_it_can_determine_the_verb_independently
    line = ['GET / HTTP/1.1']
    result = 'GET'
    assert_equal result, check_type_of_request(line)
  end

  def test_it_can_determine_the_path_independently
    line = ['GET / HTTP/1.1']
    result = '/'
    assert_equal result, requested_path(line)
  end

  def test_it_can_find_the_content_length_for_a_post_request
    line = ['POST / HTTP/1.1', 'Content-Length: 44']
    result = 44
    assert_equal result, find_content_length(line)
  end
end
