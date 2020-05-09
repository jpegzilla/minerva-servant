# frozen_string_literal: true

# module for logging things
module Logbook
  # dev mode logging
  class Dev
    def self.log(data, break_around = true)
      return unless $PROCESS_MODE == 'development'

      if break_around
        puts
        puts caller.first
        pp data
        puts
      else
        puts caller.first
        pp data
      end
    end
  end
end
