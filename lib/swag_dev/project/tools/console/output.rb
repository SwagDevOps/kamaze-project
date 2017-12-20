# frozen_string_literal: true

require_relative '../console'
require 'pastel'

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
    Pastel.new(enabled: output.tty?).decorate(s, *args)
  end
end
