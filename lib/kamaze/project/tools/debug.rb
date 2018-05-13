# frozen_string_literal: true

require_relative '../tools'
require 'tty/screen'
require 'active_support/inflector'

# Provides colored pretty-printer automagically
#
# @see http://ruby-doc.org/stdlib-2.0.0/libdoc/pp/rdoc/PP.html
# @see https://github.com/pry/pry
class Kamaze::Project::Tools::Debug < Kamaze::Project::Tools::BaseTool
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
  def dump(obj, out = STDOUT, width = nil)
    width ||= TTY::Screen.width || 79

    printer_for(out).pp(obj, out, width)
  end

  # Get printer for given output
  #
  # @param [IO] out
  # @return [PP]
  def printer_for(out)
    out_tty = out.respond_to?(:isatty) and out.isatty

    printers[out_tty ? 0 : 1]
  end

  # Get printers
  #
  # First printer SHOULD be the color printer, secund is the default printer
  #
  # @return [Array<PP>]
  def available_printers
    load_printers

    default = '::PP'

    [
      proc do
        target = '::Pry::ColorPrinter'

        Kernel.const_defined?(target) ? target : default
      end.call,
      default
    ].map { |n| inflector.constantize(n) }.freeze
  end

  protected

  # @return [Boolean|nil]
  attr_reader :warned

  # @return [Class]
  attr_reader :inflector

  def setup
    @inflector ||= ActiveSupport::Inflector
    @printers = available_printers
  end

  # Load printers requirements (on demand)
  #
  # @return [self]
  def load_printers
    Object.const_set('Pry', Class.new) unless Kernel.const_defined?('::Pry')

    begin
      load_printer_requirements
    rescue LoadError => e
      self.class.__send__('warned=', !!warn_error(e)) unless warned?
    end

    self
  end

  # @raise [LoadError]
  # @return [self]
  def load_printer_requirements
    ['pp',
     'coderay',
     'pry/pager',
     'pry/color_printer'].each { |req| require req }

    self
  end

  # Display the given exception message (followed by a newline) on STDERR
  #
  # unless warnings are disabled (for example with the -W0 flag).
  #
  # @param [Exception] error
  # @return [Array<String>]
  def warn_error(error)
    formats = { from: caller(1..1).first, mssg: error.message }
    message = '%<from>s: %<mssg>s' % formats

    warn(message)

    formats.values
  end
end
