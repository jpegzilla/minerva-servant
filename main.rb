# frozen_string_literal: true

require_relative 'server'

$PROCESS_MODE = 'production'

ARGV.each do |arg|
  $PROCESS_MODE = 'development' if arg == '--development'
end

server = Server::HTTPServer.new(8888)

server.listen
