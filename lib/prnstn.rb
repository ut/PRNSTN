@@env = 'production' unless @env

require 'twitter'
require 'date'
require 'cupsffi'

require 'prnstn/version'
require 'prnstn/config'
require 'prnstn/logger'
require 'prnstn/database/schema'
require 'prnstn/smc'
require 'prnstn/fakeapi'


module Prnstn
  class Main

    attr_accessor :logger
    attr_accessor :log
    attr_reader :options, :quit

    def initialize(options)

      @options = options

      # default
      if !options[:onpush_print]
        options[:instant_print] = true
      end

    end


    def prepare
      # TODO:
      # implement $DEBUG and logfile warnings on/off

      @logger = Prnstn::Logger.new('log/prnstn.log')
      @logger.log('----------------')
      @logger.log("#{Prnstn::NAME} #{Prnstn::VERSION} on a #{ENV['_system_name']} #{ENV['_system_version']} machine")
      @logger.log('----------------')
      @logger.log('Init application...')
      if ENV['REMOTE_TOKEN']
        @logger.log('Prnstn is starting...')
        @logger.log("Token provided: #{Prnstn::REMOTE_TOKEN}")
        if Message.all.count == 0
          initial_message = [
            sid: 1,
            title: "Hello World",
            body: "I'm here!\n A message from #{Prnstn::NAME}\n",
            imageurl: "",
            date: Time.now,
            queued: true
          ]
          Message.create(initial_message)
          @logger.log("Datebase first run: Created initial message")
        end
        @messages = Message.all
        @logger.log("Datebase lookup: #{@messages.count} messages stored")

      else
        @logger.log('No token provided. Quitting...')
        'No token provided. Quitting...!'
      end
    end

    def run!

      prepare

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
      Prnstn::SMC.new

      if options[:onpush_print]
        # 4 queue calculations (storage)
        # read_saved_queue or init new(empty) one
        # remove old msg (msg.age  > 1.week)
        # add newest msg from SMC
      else
        @logger.log('INSTANT PRINT... omitting queue calculations')
      end

      # 5 print
      if options[:instant_print]
        @logger.log('INSTANT PRINT mode...')

        # print first messsage
        @logger.log('INSTANT PRINT... printing a "hello world" message')

        job = ''
        # first run, print default image
        if @options[:live_run]
          # job = @printer.print_data('hello world', 'text/plain')
          job = @printer.print_file('assets/INTPRN_hello_world.png');
        else
          @logger.log('INSTANT PRINT... printing disabled, skipping (dry run mode)')
        end

        while !quit
          @logger.log('INSTANT PRINT listening')
          # TODO
          #  check via Prnstn::SMC
          #  print all messages since last run/llop!
          messages = Message.where(printed: false)
          if messages && messages.count > 0
            @logger.log("INSTANT PRINT... printing #{messages.count} messages")

            messages.each do |m|

              # TODO move printing to an extra class, more generic: screen/log output only, pdf print, real print
              data = "-----------------\n"
              data << "##{m.id} // #{m.sid} // #{m.date}\n"

              # TODO: parse body for links, get image, display.
              data << "#{m.body}\n"
              data << "-----------------\n"
              if @options[:live_run]
                job = @printer.print_data(data, 'text/plain')
              else
                @logger.log('INSTANT PRINT... printing disabled, skipping (dry run mode)')
                @logger.log(data)
              end
              m.printed = true
              m.save!
            end

          else
            @logger.log("INSTANT PRINT... no new messages, nothing to print")
          end
          sleep(5)
        end
        #

      end

    end

    def prn_find
      @logger.log('Finding a printer...')
      # get all printers
      printers = CupsPrinter.get_all_printer_names

      # prints.each do |p|
      if printers.count > 0
        # TODO: read param of printer ID, otherwise try to find it via name regex
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
      if @options[:live_run]
        job = @printer.print_data('hello world', 'text/plain')
        if job && !job.nil? && job.status
          @logger.log("Job status #{job.status}")
        else
          @logger.log("No job has been done")
        end
      else
        @logger.log('TEST PRINT... printing disabled, skipping (dry run mode)')
      end

    end

    def print_message


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
