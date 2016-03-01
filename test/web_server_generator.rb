# frozen_string_literal: true
# Web Server Generator
class WebServerGenerator
  def render(table)
    config_db = table.hashes.each_with_object(
      Port: 8000
    ) do |e, a|
      a[e[:option].to_sym] = e[:value]
    end

    response_field = config_db.delete('response')

    response_data = if response_field
                      {
                        'body' => '"Example Domain"'
                      }.merge Hash(JSON.parse(response_field))
                    else
                      {
                        'body' => '"Example Domain"'
                      }
                    end

    response = response_data.each_with_object([]) do |(k, v), a|
      if k == 'header'
        v.each do |header_k, header_v|
          a << format('res.%s["%s"] = "%s"', k, header_k, header_v)
        end
      else
        a << format('res.%s = %s', k, v)
      end
    end.join("\n")

    config = config_db.map { |k, v| format('%s: %s', k, v) }.join(', ')

    <<~EOS
    #!/usr/bin/env ruby

    require 'webrick'
    server = WEBrick::HTTPServer.new #{config}

    server.mount_proc '/' do |req, res|
      #{response}
    end

    server.start
    EOS
  end
end
