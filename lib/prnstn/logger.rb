require 'fileutils'

module Prnstn
  class Logger

    attr_accessor :log

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

      $PLogger = self
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

  # Convenience wrapper for logging, allows us to use Prnstn.log
  # (fame goes to Mongrel developers)
  def self.log(*args)
    # If no logger has been defined yet at this point, log to STDOUT.
    $PLogger ||= Prnstn::Log.new(STDOUT, :debug)
    $PLogger.log(*args)
  end
end
