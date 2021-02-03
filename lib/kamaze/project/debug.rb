# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../project'

# Provides colored pretty-printer automagically
#
# @see http://ruby-doc.org/stdlib-2.0.0/libdoc/pp/rdoc/PP.html
# @see https://github.com/pry/pry
class Kamaze::Project::Debug
  def initialize
    self.tap do
      @printers = load_printers.yield_self { available_printers }.freeze
    end.freeze
  end

  class << self
    # @return [Boolean]
    def warned?
      @warned || false
    end

    protected

    # @return [Boolean]
    attr_accessor :warned
  end

  # @return [Array<PP>]
  attr_reader :printers

  # @return [Boolean]
  def warned?
    self.class.warned?
  end

  # Outputs obj to out in pretty printed format of width columns in width.
  #
  # If out is omitted, ``STDOUT`` is assumed.
  # If width is omitted, ``79`` is assumed.
  #
  # @param [Object] obj
  # @param [IO] out
  # @param [Fixnum] width
  # @see http://ruby-doc.org/stdlib-2.2.0/libdoc/pp/rdoc/PP.html
  def dump(obj, out = $stdout, width = nil)
    width ||= screen_width || 79

    unless out.respond_to?(:isatty)
      out.singleton_class.define_method(:isatty) { false }
    end

    printer_for(out).pp(obj, out, width)
  end

  # Get printer for given output
  #
  # @param [IO] out
  # @return [PP]
  def printer_for(out)
    printers.fetch(out.isatty ? 0 : 1)
  end

  # Get printers
  #
  # First printer SHOULD be the color printer, secund is the default printer
  #
  # @return [Array<PP>]
  def available_printers
    require 'dry/inflector'

    '::PP'.yield_self do |default|
      # @formatter:off
      [
        'Pry::ColorPrinter'.yield_self do |cp|
          Kernel.const_defined?(cp) ? cp : default
        end,
        default
      ].map { |n| Dry::Inflector.new.constantize(n) }.freeze
      # @formatter:on
    end
  end

  protected

  # @return [Integer]
  def screen_width
    require 'tty/screen'

    TTY::Screen.width
  end

  # Load printers requirements.
  #
  # @return [self]
  def load_printers
    self.tap do
      Object.const_set('Pry', Class.new) unless Kernel.const_defined?('::Pry')

      begin
        load_requirements
      rescue LoadError => e
        self.class.__send__('warned=', !!warn_error(e)) unless warned?
      end
    end
  end

  # Load requirements.
  #
  # @raise [LoadError]
  # @return [self]
  def load_requirements
    self.tap do
      # noinspection RubyLiteralArrayInspection,RubyResolve
      ['pp', 'coderay', 'pry'].each { |req| require req }
    end
  end

  # Display the given exception message (followed by a newline) on STDERR
  #
  # unless warnings are disabled (for example with the -W0 flag).
  #
  # @param [Exception] error
  # @return [nil]
  def warn_error(error)
    { from: caller(1..1).first, mssg: error.message }.tap do |formats|
      return warn('%<from>s: %<mssg>s' % formats)
    end
  end
end
