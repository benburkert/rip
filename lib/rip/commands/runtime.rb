module Rip
  module Commands
    o 'rip runtime COMMAND'
    x 'Commands for managing your ruby runtime.'
    x 'Type rip runtime to see valid options.'
    def runtime(options = {}, command = nil, *args)
      if command && Rip::Runtime.commands.include?(command)
        ui.puts 'runtime: ' + Rip::Runtime.call(command, *args).to_s
      else
        Rip::Runtime.show_help :runtime
        ui.puts '', "current runtime: #{Rip::Runtime.active}"
      end
    end
  end
end