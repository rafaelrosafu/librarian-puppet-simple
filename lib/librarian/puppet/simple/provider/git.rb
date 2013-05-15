module Librarian
  module Puppet
    module Simple
      module Provider
        class Git
          extend Librarian::Puppet::Simple::Util

          def self.key
            :git
          end

          def self.install(module_path, module_name, options)
            repo = options[:git]
            ref = options[:ref]

            module_dir = File.join(module_path, module_name)

            Dir.chdir(module_path) do
              print_verbose "cloning #{repo}"
              system_cmd("git clone #{repo} #{module_name}")
              Dir.chdir(module_dir) do
                system_cmd('git branch -r')
                system_cmd("git checkout #{ref}") if ref
              end
            end
          end
        end
      end
    end

    # Register the provider
    Simple.providers.register Simple::Provider::Git
  end
end