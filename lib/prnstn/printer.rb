module Prnstn
  class Printer

    def initialize(options)

      @options = options


      Prnstn.log('Finding a @printer...')
      # get all printers
      printers = CupsPrinter.get_all_printer_names

      # prints.each do |p|
      if printers.count > 0
        # TODO: read param of @printer ID, otherwise try to find it via name regex
        @printer = CupsPrinter.new(printers.first)
        Prnstn.log("A @printer was found! *#{@printer.name}*")
        @printer
      else
        Prnstn.log('No @printer available on this machine. Quitting...'.red)
        # @printer = Array.new
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

      test_print

    end

    def test_print

      Prnstn.log('Print test...')
      if @options && @options[:live_run]
        # job = @printer.print_data('hello world', 'text/plain')
        job = @printer.print_file('assets/INTPRN_hello_world.png');
        if job && !job.nil? && job.status
          Prnstn.log("Job status #{job.status}")
        else
          Prnstn.log("No job has been done")
        end
      else
        Prnstn.log('TEST PRINT... printing disabled, skipping (dry run mode)')
      end

    end

    def print(m)
      data = ''
      # TODO: more generic: screen/log output only, pdf print, real print
      # data << "-----------------\n"
      data << "##{m.id} // #{m.sid} // #{m.date}\n"

      # TODO: parse body for links, get image, display.
      data << "#{m.body}\n"
      # data << "-----------------\n"
      if @options && @options[:live_run]
        Prnstn.log('PRINT... printing a job')
        job = @printer.print_data(data, 'text/plain')
        if m.imageurl && m.imageurl.length > 0
          Prnstn.log("PRINT... file from #{m.imageurl}");
          job_image = @printer.print_file(m.imageurl);
        end
      else
        Prnstn.log('PRINT... printing disabled, skipping (dry run mode)')
        Prnstn.log(data)
      end
      m.printed = true
      m.save!
    end

  end
end