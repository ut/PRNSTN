require 'prnstn/version'
require 'prnstn/config'
require 'prnstn/logger'
require 'prnstn/smc'
require 'prnstn/fakeapi'

require 'twitter'
require 'date'

module Prnstn
  class Main

    attr_accessor :logger

    def initialize(*)
      @logger = Prnstn::Logger.new('log/prnstn.log')
      @logger.log('----------------')
      @logger.log("#{Prnstn::NAME} #{Prnstn::VERSION} on a #{ENV['_system_name']} #{ENV['_system_version']} machine")
      @logger.log('----------------')
      @logger.log('Init application...')
      if ENV['REMOTE_TOKEN']
        @logger.log('Prnstn is starting...')
        @logger.log("Token provided: #{Prnstn::REMOTE_TOKEN}")
      else
        @logger.log('No token provided. Quitting...')
        exit
      end
    end

    def call
      @logger.log('Start application...')
      # TODO

      # 1 check printer status
      prn_find
      prn_status
      prn_test_print
      prn_status

      # 2 API comm w/CTRLSRV
      # check_remote_host
      # check_token
      # get_config_update (otherwise use defaults)

      # 3 SMC setup and status
      # check_smc_setup
      # read msg from SMC

      # 4 queue calculations (storage)
      # read_saved_queue or init new(empty) one
      # remove old msg (msg.age  > 1.week)
      # add newest msg from SMC

    end

    def prn_find
      @logger.log('Finding a printer...')
      # get all printers
      printers = CupsPrinter.get_all_printer_names

      # prints.each do |p|
      if printers.count > 0
        @printer = CupsPrinter.new(printers.first)
        @logger.log("A printer was found! *#{@printer.name}*")

      else
        @logger.log('No printer available on this machine. Quitting...')
        exit
      end
    end

    def prn_status
      @logger.log('Checking printer status...')

      # show all attributes:
      # puts printer.attributes
      # puts printer.state[:state]
      # :state is :idle, :printing, or :stopped.
      # TODO handle printer errrors, like paper jam

      last_used = Time.at(@printer.attributes["printer-state-change-time"].to_i)

      # TODO move this to a helper function!
      if @printer.state[:reasons]
        reason = @printer.state[:reasons].join(',')
        reason = "~ \"#{reason}\""
      else
        reason = '~ ...'
      end


      state = "*#{@printer.name}* | State: #{@printer.state[:state]} #{reason}  | Last usage: #{last_used})"
      @logger.log("#{state}")

    end

    def prn_test_print
      @logger.log('Print test...')
      job = ''
      # job = @printer.print_data('hello world', 'text/plain')
      if !job.empty?
        @logger.log("Job status #{job.status}")
      else
        @logger.log("No job has been done")
      end

    end

    def send
      Prnstn::Logger('msg sent')
    end

    def test
      msg = 'Just a Test'
      Prnstn.test(msg)
      Prnstn::Logger('printer tested')
    end

  end
end
