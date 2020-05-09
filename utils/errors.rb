# frozen_string_literal: true

# simple methods for showing error messages
module ErrorMessage
  def self.invalid_key_error(method, key)
    raise ArgumentError, "invalid key '#{key}' used as parameter to #{method}."
  end

  def self.invalid_http_method_error(key, val, method)
    raise ArgumentError, "#{key} used to access #{method}. use #{val}."
  end

  def self.missing_arguments_error(method)
    raise ArgumentError, "missing arguments to #{method}"
  end

  def self.missing_parameter_error(method)
    raise ArgumentError, "missing url parameter id to #{method}."
  end

  def self.invalid_structure_error(method, keys)
    raise ArgumentError, "invalid object with keys #{keys} passed to #{method}."
  end

  def self.make_http_error(status, message)
    error = { status: status }

    case status.to_s.chr.to_i
    when 4
      error[:message] = "bad request: #{message}"
    when 5
      error[:message] = "server error: #{message}"
    end

    error.to_json
  end
end

# module for multiple custom error classes
module CustomError
  # for throwing a server error (like 500)
  class ServerError < StandardError
    def initialize(message = 'an internal server error occurred.')
      super
    end
  end
end
