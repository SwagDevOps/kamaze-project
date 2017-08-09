# frozen_string_literal: true

require 'swag_dev/project'
require 'swag_dev/project/struct'

require 'sham'

module SwagDev::Project::Sham
  class << self
    # Define a sham
    #
    # @param [Symbol] name
    # @return [nil]
    # @yieldreturn [Sham::Config]
    def config(name)
      Sham.config(sham_class, name)

      pp block_given?

      yield(Sham::Config.new(sham_class, name)) if block_given?
    end

    # Retrieve a sham
    #
    # @param [Symbol] name
    # @return [SwagDev::Project::Struct]
    def sham!(name, *args)
      unless sham_class.sham_config(name)
        raise ArgumentError, "No sham named `#{name}'"
      end

      sham_class.sham!(*([name] + args))
    end

    protected

    # @return [SwagDev::Project::Struct]
    def sham_class
      SwagDev::Project::Struct
    end
  end
end
