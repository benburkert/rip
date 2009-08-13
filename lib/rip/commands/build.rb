# file: lib/rip/commands/build.rb
#
# rip build
# Builds Ruby extensions for installed packages

module Rip
  module Commands
    def build(options={}, *packages)
      runtimes = Array(options.fetch(:runtimes, manager.runtimes))
      packages.each do |package_name|
        package = manager.package(package_name)
        alerted = false

        runtimes.each do |runtime|
          Dir["#{package.cache_path}/**/extconf.rb"].each do |build_file|
            if !alerted
              ui.puts "rip: building #{package_name}"
              alerted = true
            end

            build_dir = File.dirname(build_file)
            Dir.chdir(build_dir) do
              system "'#{runtime}' extconf.rb"
              system "make clean"
              system "make install RUBYARCHDIR='#{Rip::Runtime.runtime_dir(runtime)}'"
            end
          end

          if !alerted && !options[:quiet]
            ui.puts "rip: don't know how to build #{package_name}"
          end
        end
      end
    end
  end
end
