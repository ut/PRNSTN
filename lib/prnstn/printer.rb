module Prnstn
  class Printer

    def initialize(options)

      @options = options
      Prnstn.log('Looking for a @printer...')
      printers = CupsPrinter.get_all_printer_names

      if printers.count == 0
        Prnstn.log('No printer available on this machine. Quitting...'.red)
        print 'No printer available on this machine. Quitting...'
        exit
      end
      # TODO: read param of @printer ID, otherwise try to find it via name regex
      if printers.count == 1
        @printer = CupsPrinter.new(printers[0])
        Prnstn.log("A printer was found! *#{@printer.name}*")
      elsif options[:printer]
        @printer = CupsPrinter.new(printers[options[:printer].to_i])
        Prnstn.log("A printer was selected! Nr. #{options[:printer]} *#{@printer.name}*".green)
      else
        Prnstn.log("Multiple printer was found! Please restart the application w/ ".red)
        printers.each_with_index do |p,i|
          Prnstn.log("#{i} #{p}".red)
        end
        puts "Multiple printer was found! Please restart the application and define a printer w/-p NUMBER_OF_PRINTER (Check logfile for a list of available printers"
        exit
      end
    end

    def status()
      Prnstn.log('Checking @printer status...')

      # show all attributes:
      # puts @printer.attributes
      # puts @printer.state[:state]
      # :state is :idle, :printing, or :stopped.
      # TODO handle @printer errrors, like paper jam

      last_used = Time.at(@printer.attributes["@printer-state-change-time"].to_i)

      # TODO move this to a helper function!
      if @printer.state[:reasons]
        reason = @printer.state[:reasons].join(',')
        reason = "~ \"#{reason}\""
      else
        reason = '~ ...'
      end


      state = "*#{@printer.name}* | State: #{@printer.state[:state]} #{reason}  | Last usage: #{last_used})"
      Prnstn.log("#{state}")

      if @options && @options[:live_run]
        test_print
      else
        Prnstn.log('TEST PRINT... printing disabled, skipping (dry run mode)'.yellow)
      end

    end

    def test_print
      Prnstn.log('Print test...')
      # job = @printer.print_data('hello world', 'text/plain')
      job = @printer.print_file("#{@options[:assetsdir]}/INTPRN_hello_world.png");
      if job && !job.nil? && job.status
        Prnstn.log("Job status #{job.status}")
      else
        Prnstn.log("No job has been done")
      end
    end

    def print_header
      Prnstn.log('Print header...')
      # job = @printer.print_file("#{@options[:assetsdir]}/INTPRN_pause1_85x85mm.png");
      job = @printer.print_file("#{@options[:assetsdir]}/INTPRN_solidaritycity_pattern_85x170mm.png");
      if job && !job.nil? && job.status
        Prnstn.log("Job status #{job.status}")
      end
    end

    def print_pause
      Prnstn.log('Print pause...')
      job = @printer.print_file("#{@options[:assetsdir]}/INTPRN_pause2_85x85mm.png");
      if job && !job.nil? && job.status
        Prnstn.log("Job status #{job.status}")
      end
    end

    def print(m)
      data = ''
      # data << "##{m.id} // #{m.sid} // #{m.date}\n"
      data << "@#{m.screen_name} #{m.created_at}\n"

      # TODO: parse body for links, get image, display.
      data << "#{m.body}\n"
      # data << "-----------------\n"
      if @options && @options[:live_run]
        Prnstn.log('PRINT... printing a job')
        job = @printer.print_data(data, 'text/plain')
        Prnstn.log("PRINT... status: #{job.status}")

        if m.imageurl && m.imageurl.length > 0
          Prnstn.log("PRINT... file from #{m.imageurl}");
          if File.exist? m.imageurl
            job_image = @printer.print_file(m.imageurl);
            Prnstn.log("PRINT... status: #{job_image.status}")
          else
            Prnstn.log('PRINT... file could not be found on disk!'.red)
          end
        end
        Prnstn.log('PRINT... send to printer queue!')
        Prnstn.log(data.colorize(:color => :white, :background => :light_black))
        m.printed = true
        m.save!
      else
        Prnstn.log('PRINT... printing disabled, skipping (dry run mode)'.yellow)
        Prnstn.log(data.colorize(:color => :white, :background => :light_black))
      end
    end

  end
end