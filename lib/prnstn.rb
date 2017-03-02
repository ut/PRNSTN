$env = 'production' unless $env

require 'twitter'
require 'date'
require 'cupsffi'

require 'prnstn/version'
require 'prnstn/config'
require 'prnstn/logger'
require 'helper/fakeapi'
require 'prnstn/database/schema'
require 'prnstn/printer'
require 'prnstn/smc'




module Prnstn
  class Main

    attr_accessor :logger
    attr_accessor :log
    attr_reader :options, :quit

    def initialize(options)

      if MACHINE == 'raspberry'
        require 'wiringpi'
      end
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
      @logger.log("#{Prnstn::NAME} #{Prnstn::VERSION} on a  machine")
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
          Message.save!(initial_message)
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
      printer = Prnstn::Printer.new()
      printer.status
      printer.test_print
      printer.status

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

      ### 5 print

      # first run, print default image
      @logger.log('PRINT... printing a "hello world" message')

      job = ''
      if @options[:live_run]
        job = @printer.print_file('assets/INTPRN_hello_world.png');
      else
        @logger.log('PRINT... printing disabled, skipping (dry run mode)')
      end


      if options[:onpush_print]
        @logger.log('ONPUSH PRINT mode...')

        if MACHINE == 'raspberry'

          # setup GPIO, get pin #4
          io = WiringPi::GPIO.new do |gpio|
            gpio.pin_mode(4, WiringPi::INPUT)
          end

          # wiringPi pin #4 eq Raspi pin 23
          pin_state = io.digital_read(4) # Read from pin 1
          puts pin_state

          loop do
            pin_state = io.digital_read(4) # Read from pin 1

            # TODO: if run > 20.times check SMC for a new message
            # Prnstn::SMC.new

            if pin_state == 0
              @logger.log("INSTANT PRINT... push! push!")
              # TODO: smart calc of the latest x messages
              messages = Message.limit(3)
              if messages && messages.count > 0

                @logger.log("INSTANT PRINT... printing #{messages.count} messages")

                messages.each do |m|
                  printer.print(m)
                end
              end

           else
              puts "-----"
           end
           io.delay(600)
          end

        else
          @logger.log("ONPUSH PRINT... sorry you're on a machine without a GPIO port. quitting..")
          exit
        end



      elsif options[:instant_print]
        @logger.log('INSTANT PRINT mode...')

        while !quit
          @logger.log('INSTANT PRINT listening')
          # TODO: check via Prnstn::SMC!!!!

          #  print all messages since last run/loop!
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
                if m.imageurl && !m.imageurl.nil?
                  job_image = @printer.print_file(m.imageurl);
                end
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

      else
        raise 'Error'
      end

    end


  end
end
