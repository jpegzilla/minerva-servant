# frozen_string_literal: true

require_relative 'server'

server = Server::HTTPServer.new(8888)

server.listen
