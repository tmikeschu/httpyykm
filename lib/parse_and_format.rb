require 'socket'

module ParseAndFormat
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
      output[:Content_Length] = line.split(':')[1].strip if line.include?('Content-Length')
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

  def word_search(word)
    dictionary = File.readlines("/usr/share/dict/words")
    formatted_dictionary = dictionary.map { |word| word.downcase.rstrip }
    formatted_dictionary.include?(word)? "a known" : "not a known"
  end

  def find_word(lines)
    requested_path(lines)[18..-1]
  end

  def check_type_of_request(lines)
    data = comb_and_assign_to_debugger(lines)
    data[:Verb]
  end

  def find_content_length(lines)
    data = comb_and_assign_to_debugger(lines)
    data[:Content_Length].to_i
  end

  def read_from_post_request(client, content_length)
    client.read(content_length).to_i
  end

end
