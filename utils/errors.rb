# frozen_string_literal: true

# simple methods for showing error messages
module ErrorMessage
  def self.invalid_key_error(method, key)
    raise ArgumentError, "invalid key '#{key}' used as parameter to #{method}."
  end

  def self.missing_arguments_error(method)
    raise ArgumentError, "missing arguments to #{method}"
  end

  def self.missing_parameter_error(method)
    raise ArgumentError, "missing url parameter id to #{method}."
  end

  def self.make_http_error(status, message)
    error = {
      status: status,
      message: message
    }

    error.to_json
  end
end
