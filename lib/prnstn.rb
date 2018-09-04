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

      # check env, set
      puts $DEBUG
      if $DEBUG
        print "debug mode enabled"
        $env = 'debug'
      end

      # daemonization will change CWD so expand relative paths now
      if logfile?
        options[:logfile] = File.expand_path(logfile)
      else
        options[:logfile] = File.expand_path('log/prnstn.log')
      end

      if pidfile?
        options[:pidfile] = File.expand_path(pidfile)
      else
        options[:pidfile] = File.expand_path('log/pid')
      end

      options[:assetsdir] = File.expand_path('assets')


    end


    def daemonize?
      options[:daemonize]
    end

    def logfile
      options[:logfile]
    end

    def pidfile
      options[:pidfile]
    end

    def logfile?
      !logfile.nil?
    end

    def pidfile?
      !pidfile.nil?
    end

    def write_pid
      if pidfile?
        begin
          File.open(pidfile, ::File::CREAT | ::File::EXCL | ::File::WRONLY){|f| f.write("#{Process.pid}") }
          at_exit { File.delete(pidfile) if File.exists?(pidfile) }
        rescue Errno::EEXIST
          check_pid
          retry
        end
      end
    end

    def check_pid
      if pidfile?
        case pid_status(pidfile)
        when :running, :not_owned
          puts "A server is already running. Check #{pidfile}"
          exit(1)
        when :dead
          File.delete(pidfile)
        end
      end
    end

    def pid_status(pidfile)
      return :exited unless File.exists?(pidfile)
      pid = ::File.read(pidfile).to_i
      return :dead if pid == 0
      Process.kill(0, pid)      # check process status
      :running
    rescue Errno::ESRCH
      :dead
    rescue Errno::EPERM
      :not_owned
    end

    def daemonize
      exit if fork
      Process.setsid
      exit if fork
      Dir.chdir "/"
    end

    def redirect_output
      FileUtils.mkdir_p(File.dirname(logfile), :mode => 0755)
      FileUtils.touch logfile
      File.chmod(0644, logfile)
      $stderr.reopen(logfile, 'a')
      $stdout.reopen($stderr)
      $stdout.sync = $stderr.sync = true
    end

    def suppress_output
      $stderr.reopen('/dev/null', 'a')
      $stdout.reopen($stderr)
    end

    def trap_signals
      trap(:QUIT) do   # graceful shutdown of run! loop
        @quit = true
      end
    end

    def prepare
      puts "... switching to logger"
      # TODO: implement $DEBUG and logfile warnings on/off
      @logger = Prnstn::Logger.new(@options[:logfile])
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
      # return "PRNSTN prepared"
    end

    def run!

      puts "running"
      # quit = 'false'
      # check_pid
      # daemonize if daemonize?
      # write_pid
      # trap_signals

      prepare

      # while !quit
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
      # end
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
