# frozen_string_literal: true

require 'swag_dev/cli'
require 'pastel'

class SwagDev::Cli::Output
  def initialize(to = STDOUT)
    @output = to
  end

  def writeln(s, *args)
    output.puts(decorate(s, *args))
  end

  def decorate(s, *args)
    Pastel.new(enabled: output.tty?).decorate(s, *args)
  end

  protected

  attr_reader :output
end
