# frozen_string_literal: true

require_relative './../../utils/errors'
require_relative './../../utils/object_utils'

# module for performing operations on the user database
module UserOps
  include ErrorMessage
  include OUtil
  # class for performing crud operations on the user database.
  class Crud
    def initialize(db_client)
      @db_interface = db_client.database
      @collection = db_client[:ma_users]
    end

    def validate_request(request)
      valid_methods = %w[GET POST DELETE PUT PATCH]

      unless valid_methods.include? request[:method]
        return ErrorMessage.make_http_error(400, 'unacceptable method.')
      end

      if request[:op].nil?
        return ErrorMessage.make_http_error(400, 'undefined endpoint.')
      end

      return if respond_to? request[:op]

      ErrorMessage.make_http_error(400, "undefined endpoint '#{request[:op]}.'")
    end

    def req(request)
      validation = validate_request(request)

      return validation unless validation.nil?

      endpoint_loc = request[:op]

      begin
        method(endpoint_loc).call(request).to_json
      rescue ArgumentError => e
        ErrorMessage.make_http_error(400, e.message)
      end
    end

    # starting point for user creation process
    def create(request)
      OUtil.check_http_method(request[:method], 'POST', __method__)

      user_to_create = request[:data]

      valid_keys = {
        dateCreated: String,
        password: String,
        user_id: String,
        name: String
      }

      OUtil.check_object_keys(user_to_create.keys, valid_keys, __method__)

      create_user(user_to_create)
    end

    # if a user_id already exists, returns a 200 message.
    # if not, creates a new user in the database, or
    # provides an error message upon failure.
    def create_user(user)
      existing = @collection.find(user_id: user['user_id']).first

      return { status: 200, response: 'user exists.' } unless existing.nil?

      result = @collection.insert_one(user) if existing.nil?

      if result.n == 1
        { status: 201, response: 'created new user.', count: result.n }
      else
        { status: 500, response: 'created new user.', count: result.n }
      end
    end

    # find a document, using a request object. only finds
    # by user_id.
    def find(request)
      OUtil.check_http_method(request[:method], 'GET', __method__)

      user = request[:data]

      result = @collection.find(user_id: user['user_id']).first

      if result.nil?
        { status: 404, response: 'user not found.' }
      else
        { status: 200, response: result }
      end
    end

    def update(request)
      OUtil.check_http_method(request[:method], 'PATCH', __method__)

      user = request[:data]
      update_to_do = update_user(user)

      res = @collection.update_one({ user_id: user['user_id'] }, update_to_do)

      if res.n == 1
        { status: 200, response: 'updated user info.', count: res.n }
      else update_to_do
      end
    end

    def update_user(user)
      update_to_do = { '$set' => {} }

      existing = @collection.find(user_id: user['user_id']).first

      return { status: 404, response: 'user not found.' } if existing.nil?

      user.keys.each do |key|
        update_to_do['$set'][key] = user[key]
      end

      update_to_do
    end

    def all(request)
      OUtil.check_http_method(request[:method], 'GET', __method__)

      table = []

      @collection.find.each do |document|
        table.push document
      end

      table
    end

    def delete(request)
      OUtil.check_http_method(request[:method], 'DELETE', __method__)

      user_data = request[:data]
      id = user_data['user_id']

      result = @collection.delete_one(user_id: id)

      if result.deleted_count == 1
        { status: 200, response: 'deleted user.', count: result.deleted_count }
      else { status: 500, response: 'unable to delete user.' }
      end
    end
  end
end
