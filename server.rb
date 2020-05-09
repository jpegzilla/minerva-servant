# frozen_string_literal: true

require 'socket'
require 'json'

require_relative 'utils/http_utils'
require_relative 'api/api'

DATABASE_NAME = 'minerva_db'

##
# this class is made to handle requests coming from
# a single client on a tcp server.
class RequestHandler
  include HTTPUtils
  include Api

  ##
  # initializes with a client socket returned from a +TCPSocket+ object.

  def initialize(session)
    @session = session
  end

  ##
  # handles an incoming request from the open socket in +@session+.
  # constructs a formatted request object from the original request object, then
  # calls +send_final_response+ in order to send a response.
  def handle_request(request)
    url_main = request[:url].split('?')[0]

    request_object = {
      method: request[:method],
      url: url_main,
      params: HTTPUtils::URLUtils.extract_url_params(request[:url]),
      protocol: request[:protocol],
      headers: request[:headers],
      data: request[:data]
    }

    send_final_response(request_object, 200)
  end

  def send_final_response(request_object, status = 200)
    status = status.to_i

    begin
      response_from_api = get_api_response(request_object)
      response_size = response_from_api.bytesize

      responder = HTTPUtils::ServerResponse.new(@session, response_size)

      responder.respond(status, response_from_api) # send http response
    rescue StandardError => e
      { status: 500, response: e }.to_json
    end
  end

  # get the api to respond to a certain request
  def get_api_response(request)
    api = Api::ApiResponse.new(request, DATABASE_NAME)
    response_from_api = api.respond(request)

    response_from_api
  end

  # main process, allows server to handle requests
  def process(client)
    @request = client.gets
    # wait until server isn't recieving anything
    return if @session.gets.nil?
    return if @session.gets.chop.length.zero?

    request_made = HTTPUtils.make_proper_request(client, @request)

    return if request_made[:url] == '/favicon.ico' # ignore favicon request

    request_to_handle = HTTPUtils.make_request_object(request_made)

    handle_request(request_to_handle)
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
