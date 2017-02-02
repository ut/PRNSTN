require 'fileutils'

module Prnstn
  class Logger
    # concept from mongrel gem > logger
    # => https://github.com/mongrel/mongrel/blob/master/lib/mongrel/logger.rb

    def initialize(log)

      # TODO: get file path from config
      # TODO: check if file exists
      #
      if log.respond_to?(:write)
        @log = log('hey')
        @log.sync if log.respond_to?(:sync)
      elsif File.exist?(log)
        @log = open(log, (File::WRONLY | File::APPEND))
        @log.sync = true
      else
        FileUtils.mkdir_p(File.dirname(log)) unless File.exist?(File.dirname(log))
        @log = open(log, (File::WRONLY | File::APPEND | File::CREAT))
        @log.sync = true
        log("Logfile created at #{log}")
      end
      if !RUBY_PLATFORM.match(/java|mswin/) && !(@log == STDOUT) &&
        @log.respond_to?(:write_nonblock)
        @aio = true
      end
    end

    def log(msg)
      puts "#{msg}"
      if @aio
        @log.write_nonblock("#{Time.now} || #{msg}\n")
      else
        @log.write("#{Time.now} || #{msg}\n")
      end
    end
  end
end
