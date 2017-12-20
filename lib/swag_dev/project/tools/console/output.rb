# frozen_string_literal: true

require_relative '../console'
require 'pastel'

# Provide a console output
#
# Console output can be initialized from a ``IO``
# (``STDOUT`` and/or ``STDERR``)
# a ``File``, using ``File.open()``, or a ``StringIO``.
#
# As a result, console provides a convenient way to suppress or replace
# standard outputs (keeping them untouched).
#
# Console output uses ``patsel`` to provide colored formatting.
class SwagDev::Project::Tools::Console::Output
  # @param [IO] to
  def initialize(to = STDOUT)
    @output = to
  end

  # @param [String] s
  def writeln(s, *args)
    output.puts(decorate(s, *args))
  end

  def method_missing(method, *args, &block)
    if respond_to_missing?(method)
      output.public_send(method, *args, &block)
    else
      super
    end
  end

  def respond_to_missing?(method, include_private = false)
    return true if output.respond_to?(method, include_private)

    super(method, include_private)
  end

  protected

  attr_reader :output

  # @param [String] s
  def decorate(s, *args)
    tty = output.respond_to?(:tty) ? output.tty? : false

    Pastel.new(enabled: tty).decorate(s, *args)
  end
end
