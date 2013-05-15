require 'singleton'

module Librarian
  module Puppet
    module Simple
      class Providers
        include Singleton

        class ProviderNotFound < StandardError
        end

        def initialize
          @providers = {}
        end

        def keys
          @providers.keys
        end

        def [](index)
          @providers[index]
        end

        def fetch(provider_keys, &block)
          key_found = (keys & [provider_keys].flatten).first

          raise ProviderNotFound unless key_found

          yield self[key_found]
        end

        def register(provider)
          @providers[provider.key] = provider
        end
      end

      module ProviderSupport
        def providers
          Providers.instance
        end
      end

      def self.providers_directory
        File.join(File.split(File.expand_path(__FILE__)).first, 'provider/*.rb')
      end

      def self.providers_files
        Dir[providers_directory]
      end
    end

    Simple.providers_files.each {|provider| require provider }
  end
end