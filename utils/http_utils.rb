# frozen_string_literal: true

module HTTPUtils
  # class URLUtils - for dealing with urls
  class URLUtils
    def self.extract_url_params(url)
      url_params = []

      if url.split('?')[1]

        url_params = url.split('?')[1].split('&').map do |e|
          key, value = e.split('=')

          { key: key, value: value }
        end
      end

      url_params
    end
  end
  # class ServerResponses - for sending HTTP status codes
  class ServerResponse
    def initialize(session, length)
      @session = session
      @length = length
    end

    def respond(status, response)
      method("r_#{status}").call

      # write a blank line so that the browser
      # knows that the next line is the response
      @session.puts

      @session.puts response

      @session.close
    end

    def r_200
      @session.puts 'HTTP/1.1 200 OK'
      @session.puts 'Content-Type: application/json'
      @session.puts "Content-Length: #{@length}"
    end

    def r_400
      @session.puts 'HTTP/1.1 400 Bad Request'
      @session.puts 'Content-Type: application/json'
      @session.puts "Content-Length: #{@length}"
    end

    def r_500
      @session.puts 'HTTP/1.1 500 Internal Server Error'
      @session.puts 'Content-Type: application/json'
      @session.puts "Content-Length: #{@length}"
    end
  end
end

__END__

this is the file that made me realize that the content_length header actually directly controls the length of the content in the response. I incorrectly set the content_length once as a mistake, and my responses were coming out short. interesting!
