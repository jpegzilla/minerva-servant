# frozen_string_literal: true

require 'mongo'

# initialize mongodb up here

require_relative 'endpoints/user'
require_relative 'endpoints/data'

# module Api - contains everything for dealing with the api
module Api
  include UserOps
  include DataOps

  # class Api - for handling all api requests
  class ApiResponse
    def initialize(request)
      puts 'requesting data from api'

      @method = request[:method]
      @url = request[:url]
      @params = request[:params]
    end

    # what this method returns is sent as the final response.
    def respond(request)
      endpoint_base = request[:url].split('/')[1]
      request[:op] = request[:url].split('/')[2]
      method_name = "#{endpoint_base}_endpoint_operation"

      if endpoint_base.nil?
        main_endpoint
      elsif respond_to? method_name
        method(method_name).call(request)
      else main_endpoint # show the root endpoint if no valid endpoint
      end
    end

    def main_endpoint
      { status: 200, message: 'hello world' }.to_json
    end

    def user_endpoint_operation(request)
      user_interface = UserOps::Crud.new 'empty'

      user_interface.req(request)
    end

    def data_endpoint_operation(request)
      user_interface = DataOps::Crud.new 'empty'

      user_interface.req(request)
    end
  end
end

# JSON.parse('{"hello": "world"}').to_json
