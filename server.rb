# frozen_string_literal: true

require 'socket'
require 'json'

require_relative 'utils/http_utils'
require_relative 'api/api'

# class RequestHandler
class RequestHandler
  include HTTPUtils
  include Api

  def initialize(session)
    @session = session
  end

  def handle_request(method, url, protocol)
    url_main = url.split('?')[0]

    request_object = {
      method: method,
      url: url_main,
      params: HTTPUtils::URLUtils.extract_url_params(url),
      protocol: protocol
    }

    send_final_response(request_object, 200)
  end

  def send_final_response(request_object, status = 200)
    status = status.to_i

    response_from_api = get_api_response(request_object)
    response_size = response_from_api.bytesize

    responder = HTTPUtils::ServerResponse.new(@session, response_size)

    responder.respond(status, response_from_api) # send http response
  end

  # get the api to respond to a certain request
  def get_api_response(request)
    api = Api::ApiResponse.new(request)
    response_from_api = api.respond(request)

    response_from_api
  end

  # main process, allows server to handle requests
  def process(client)
    @request = client.gets

    # wait until server isn't recieving anything
    return until @session.gets ||= ''.chomp.length.zero?

    request_method = @request.split(' ')[0]
    request_url = @request.split(' ')[1]
    request_protocol = @request.split(' ')[2]

    return if request_url == '/favicon.ico' # ignore favicon request

    handle_request(request_method, request_url, request_protocol)
  end
end

module Server
  # for initializing a simple http server.
  class HTTPServer
    def initialize(port)
      nan_error = 'invalid port number: port must be a number.'
      range_error = 'invalid port number: port must be in range [0, 65535]'

      raise nan_error unless port.is_a? Numeric
      raise range_error unless (0..65_535).include? port

      @server = TCPServer.new port
      @port = port
    end

    def listen
      puts "running on port #{@port}!"
      # create a new thread for handle each incoming request
      loop do
        Thread.start(@server.accept) do |client|
          RequestHandler.new(client).process(client)
        end
      end
    end

    def kill
      abort
    end
  end
end

at_exit { puts 'shutting down. goodbye...' }
