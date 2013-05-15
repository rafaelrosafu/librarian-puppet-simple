require_relative '../util'

module Librarian
  module Puppet
    module Simple
      module Provider
        class Tarball
          extend Librarian::Puppet::Simple::Util

          def self.key
            :tarball
          end

          def self.install(module_path, module_name)
            remote_tarball = options[:tarball]
            Dir.mktmpdir do |tmp|
              temp_file = File.join(tmp,"downloaded_module.tar.gz")
              File.open(temp_file, "w+b") do |saved_file|
                print_verbose "Downloading #{remote_tarball}..."
                open(remote_tarball, 'rb') do |read_file|
                  saved_file.write(read_file.read)
                end
                saved_file.rewind

                target_directory = File.join(module_path, module_name)
                print_verbose "Extracting #{remote_tarball} to #{target_directory}..."
                unzipped_target = ungzip(saved_file)
                tarfile_full_name = untar(unzipped_target, module_path)
                FileUtils.mv File.join(module_path, tarfile_full_name), target_directory
              end
            end
          end
        end
      end
    end

    # Register the provider
    register_provider Simple::Provider::Tarball
  end
end