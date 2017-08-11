# frozen_string_literal: true

require 'swag_dev/project'
require 'swag_dev/project/struct'

require 'sham'

# Wrapper built on top of ``::Sham`` and ``::Sham::Config``
#
# shams are used to generate sharable and configurable
# data structures.
# At any moment a sham can be redefined or overwritten,
# allowing user customization.
#
# @see SwagDev::Project::Struct
module SwagDev::Project::Sham
  class << self
    # Define a sham
    #
    # @param [Symbol] name
    # @return [nil]
    # @yieldreturn [Sham::Config]
    def config(name)
      name = name.to_sym

      Sham.config(shammable, name)
      yield(Sham::Config.new(shammable, name)) if block_given?

      self
    end

    def define(name, &block)
      name = name.to_sym

      unless has?(name)
        self.public_send(:config, name, &block)
      end

      self
    end

    # Retrieve a sham
    #
    # @param [Symbol] name
    # @return [SwagDev::Project::Struct]
    def sham(name, *args)
      name = name.to_sym

      sham!(name, *args) if has?(name)
    end

    # Retrieve a sham
    #
    # @raise [ArgumentError]
    # @param [Symbol] name
    # @return [SwagDev::Project::Struct]
    def sham!(name, *args)
      name = name.to_sym

      raise ArgumentError, "no sham for `#{name}'" unless has?(name)

      shammable.sham!(*([name] + args))
    end

    # Denote sham (by ``name``) is configured
    #
    # @param [Symbol] name
    def has?(name)
      name = name.to_sym

      if shammable.respond_to?(:sham_config)
        return nil != shammable.sham_config(name)
      end

      false
    end

    # Class used to sham
    #
    # @see SwagDev::Project::Struct
    # @return [Class]
    def shammable
      SwagDev::Project::Struct
    end
  end
end
