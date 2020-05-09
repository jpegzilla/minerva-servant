# frozen_string_literal: true

require 'mongo'

require_relative 'endpoints/user'
require_relative 'endpoints/data'

# module Api - contains everything for dealing with the api
module Api
  include UserOps
  include DataOps

  # class Api - for handling all api requests
  class ApiResponse
    def initialize(request, database_name)
      @database = database_name
      @method = request[:method]
      @url = request[:url]
      @params = request[:params]
    end

    # what this method returns is sent as the final response from
    # the api, as used in server.rb's send_final_response
    def respond(request)
      endpoint_base = request[:url].split('/')[1]
      request[:op] = request[:url].split('/')[2]
      method_name = "#{endpoint_base}_endpoint_operation"

      show_response(request, endpoint_base, method_name)
    end

    # show the correct response for the given endpoint (or the
    # lack of one)
    def show_response(request, endpoint_base, method_name)
      if endpoint_base.nil?
        main_endpoint
      elsif respond_to? method_name
        method(method_name).call(request)
      elsif request[:op].nil?
        not_found_endpoint
      else not_found_endpoint
      end
    end

    def main_endpoint
      { status: 200, message: 'hello world' }.to_json
    end

    def not_found_endpoint
      { status: 404, message: 'resource not found' }.to_json
    end

    def user_endpoint_operation(request)
      # initialize mongodb
      Mongo::Logger.logger.level = Logger::FATAL
      client = Mongo::Client.new(['127.0.0.1'], database: @database)

      user_interface = UserOps::Crud.new client

      user_interface.req(request)
    end

    def data_endpoint_operation(request)
      user_interface = DataOps::Crud.new 'empty'

      user_interface.req(request)
    end
  end
end

# JSON.parse('{"hello": "world"}').to_json
