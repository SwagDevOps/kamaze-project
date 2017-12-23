# frozen_string_literal: true

require_relative '../console'
require_relative 'output/buffer'

# Provide a console output
#
# Console output can be initialized from a ``IO``
# (``STDOUT`` and/or ``STDERR``)
# a ``File``, using ``File.open()``, or a ``StringIO``.
#
# As a result, console provides a convenient way to suppress or replace
# standard outputs (keeping them untouched).
#
# Console output uses ``cli-ui`` to provide colored formatting.
#
# @see https://github.com/Shopify/cli-ui
# @see http://ruby-doc.org/core-2.1.3/IO.html
class SwagDev::Project::Tools::Console::Output
  # @param [IO] to
  def initialize(to = STDOUT)
    @output = to
  end

  # Denote is a tty
  #
  # @return [Boolean]
  def tty?
    output.respond_to?(:'tty?') ? output.tty? : false
  end

  # Flushes any buffered data to the underlying operating system
  #
  # note that this is Ruby internal buffering only;
  # the OS may buffer the data as well
  #
  # @return [self]
  def flush
    output.flush if output.respond_to?(:flush)

    self
  end

  def method_missing(method, *args, &block)
    if respond_to_missing?(method)
      args = bufferize(*args) if formattable_on?(method.to_sym)

      return output.public_send(method, *args, &block)
    end

    super
  end

  def respond_to_missing?(method, include_private = false)
    return true if output.respond_to?(method, include_private)

    super(method, include_private)
  end

  # @!method puts(s)
  #   Writes the given objects to ``ios`` as with ``IO#print``.
  #
  #   Writes a record separator (typically a newline) after any that
  #   do not already end with a newline sequence.
  #   If called with an array argument, writes each element on a new line.
  #   If called without arguments, outputs a single record separator.
  #
  #   @param [String] s
  #   @return [nil]

  # @!method print(s)
  #   Writes the given objects to ios as with IO#print.
  #
  #   Writes the given object(s) to ``ios``.
  #
  #   The stream must be opened for writing.
  #   If the output field separator (``$,``) is not nil,
  #   it will be inserted between each object.
  #   If the output record separator (``$\``) is not nil,
  #   it will be appended to the output.
  #   If no arguments are given, prints ``$_``.
  #   Objects that aren't strings will be converted by calling
  #   their ``to_s`` method.
  #   With no argument, prints the contents of the variable ``$_``.
  #   Returns nil.
  #   @param [String] s
  #   @return [nil]

  protected

  attr_reader :output

  # Formattable methods
  #
  # @return [Array<Symbol>]
  def formattables
    [:puts, :print, :write]
  end

  # Denote given method is formattable
  #
  # @param [Symbol] method
  def formattable_on?(method)
    formattables.include?(method.to_sym)
  end

  # Bufferize given arguments
  #
  # @param [Array<String>] *strings
  # @return [Array<String>]
  def bufferize(*strings)
    strings.to_a.map { |s| Buffer.new(self, s) }
  end
end
