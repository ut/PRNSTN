$env = 'production' unless $env

require 'cupsffi'
require 'date'
require 'colorize'
# require 'twitter'

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
      if !options[:onpush_print]
        options[:instant_print] = true
      end
      if !options[:smc] || options[:smc] == true || !SMC_AVAILABLE_PLATTFORMS.include?(options[:smc])
        puts "Please select a social media plattform (#{SMC_AVAILABLE_PLATTFORMS.join(" or ")})"
        puts "Example: ./bin/prnstn -s twitter -p 1"
        exit
      else
        puts "... selected service: #{options[:smc]}"
      end
      @options = options
    end


    def prepare
      # TODO: implement $DEBUG and logfile warnings on/off
      @logger = Prnstn::Logger.new('log/prnstn.log')
      @logger.log('----------------')
      @logger.log("#{Prnstn::NAME} #{Prnstn::VERSION} on #{MACHINE}")
      @logger.log('----------------')
      # if ENV['REMOTE_TOKEN']
        @logger.log('Prnstn is starting...')
        # @logger.log("Token provided: #{Prnstn::REMOTE_TOKEN}")
        if @options[:reset_db]
          @logger.log("Resetting database".yellow)
          Message.destroy_all
        end
        if Message.all.count == 0
          initial_message = [
            sid: 1,
            title: "Hello World",
            body: "I'm here!\n A message from #{Prnstn::NAME}\n",
            imageurl: "",
            date: Time.now,
            queued: true
          ]
          Message.create!(initial_message)
          @logger.log("Datebase first run: Created initial message".green)
        end
        @messages = Message.all
        @logger.log("Datebase: #{@messages.count} messages stored".green)
      # else
        # TODO: @logger.log('No token provided'.yellow)
      # end
      return "PRNSTN prepared"
    end

    def run!
      prepare
      @logger.log('Running ...')

      # 1 check printer status
      @printer = Prnstn::Printer.new(@options)
      job = ''
      if @options[:live_run]
        @logger.log('PRINT... printing a "hello world" message')
        @printer.test_print
      else
        @logger.log('PRINT... printing disabled, skipping (dry run mode)'.yellow)
      end

      # 2 read msg from SMC
      Prnstn::SMC.new(@options)
      if options[:onpush_print]
        # 3 queue calculations (storage)
        # read_saved_queue or init new(empty) one
        # remove old msg (msg.age  > 1.week) + add newest msg from SMC
        onpush_print
      else
        @logger.log('INSTANT PRINT (default)... omitting queue calculations'.green)
        instant_print
      end
    end
    def onpush_print
      @logger.log('ONPUSH PRINT mode...')

      if MACHINE == 'raspberry'
        onpush_print_raspi
      else
        @logger.log("ONPUSH PRINT... sorry you're on a machine without a GPIO port. Maybe you want to re-run with INSTANT PRINT mode? quitting... ".red)
        exit
      end
    end

    def onpush_print_raspi
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
          @logger.log("ONPUSH PRINT... push! push!".blue)
          # TODO: smart calc of the latest x messages
          messages = Message.limit(3)
          if messages && messages.count > 0
            @logger.log("ONPUSH PRINT... printing #{messages.count} messages")
            messages.each do |m|
              @printer.print(m)
            end
          end
       else
          puts "-----"
       end
       io.delay(600)
      end
    end

    def instant_print
      @logger.log('INSTANT PRINT mode...')

      while !quit
        @logger.log('INSTANT PRINT listening')

        # TODO: re-check via Prnstn::SMC!!!!
        Prnstn::SMC.new(@options)

        #  print all messages since last run/loop!
        messages = Message.where(printed: false)

        # print last x messages (which comes first out of the API)
        # messages = Message.first(3)

        if messages && messages.count > 0
          @logger.log("INSTANT PRINT... printing #{messages.count} messages".blue)
          @logger.log("-------------------------")
          messages.each do |m|
            @printer.print(m)
          end
          @logger.log("-------------------------")
          @printer.print_header

        else
          @logger.log("INSTANT PRINT... no new messages, nothing to print".yellow)
          @printer.print_pause
        end
        @logger.log("INSTANT PRINT... sleep #{INSTANT_PRINT_INTERVAL} seconds")
        sleepery = INSTANT_PRINT_INTERVAL/2
        for i in 0..sleepery
          sleep(2)
          print "."
        end
        print "\n"
      end
    end

  end
end
