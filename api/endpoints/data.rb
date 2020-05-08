# frozen_string_literal: true

module DataOps
  # class for performing crud operations on the user database.
  class Crud
    def initialize(database)
      @db_interface = database
      @missing_arguments_error = "missing arguments to #{__method__}"
      # validate request method
      # validate request body
    end

    def req(request)
      puts
      pp request
      puts

      return unless respond_to? request[:url]

      endpoint_loc = request[:url].split('/')[1]

      method(endpoint_loc).call(request)
    end

    def create(user)
      raise @@missing_arguments_error if user.nil?

      endpoint_arg = request[:url].split('/')[1]

      puts 'calling create method'
    end

    def find(id)
      puts 'calling find method'
    end

    def update(keys, values)
      puts 'calling update method'
    end

    def delete(id)
      puts 'calling delete method'
    end
  end
end
