# frozen_string_literal: true

require_relative './../../utils/errors'

# module for performing operations on the user database
module UserOps
  include ErrorMessage

  # class for performing crud operations on the user database.
  class Crud
    def initialize(database)
      @db_interface = database

      # validate request method
      # validate request body
    end

    def req(request)
      unless respond_to? request[:op]
        return ErrorMessage.make_http_error(400, 'bad request')
      end

      endpoint_loc = request[:op]

      begin
        resp = method(endpoint_loc).call(request)
        resp.to_json
      rescue ArgumentError => e
        ErrorMessage.make_http_error(500, e.message)
      end
    end

    def create(user)
      raise ErrorMessage.missing_parameter_error(__method__) if user.nil?

      endpoint_arg = request[:url].split('/')[1]

      puts 'calling create method'
    end

    def find(id)
      puts 'calling find method'
    end

    def update(keys, values)
      puts 'calling update method'
    end

    def show_all
      puts 'showing entire database table'
    end

    # check url params to make sure they're not empty
    # on methods that require them
    def check_params(params)
      raise ErrorMessage.missing_parameter_error(__method__) if params.empty?
    end

    # make sure a key is the correct value
    def check_key(key, name)
      raise ErrorMessage.invalid_key_error(__method__, key) if key != name
    end

    def delete(req)
      puts 'calling delete method'

      params = req[:params]
      check_params(params)

      key = req[:params][0][:key]
      check_key(key, 'id')

      to_be_deleted = req[:params][0][:value]

      delete_user(to_be_deleted)
    end

    def delete_user(id_to_delete)
      puts id_to_delete

      { status: 200, response: deleted }
    end
  end
end
