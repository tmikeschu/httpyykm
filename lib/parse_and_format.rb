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
