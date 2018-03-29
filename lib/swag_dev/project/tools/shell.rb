# frozen_string_literal: true

require_relative '../tools'
require_relative 'base_tool'

class SwagDev::Project::Tools
  class Shell < BaseTool
  end
end

# Provide a REPL (based on ``Pry``)
class SwagDev::Project::Tools::Shell
  # REPL provider
  #
  # Allowing to replace ``Pry`` by ``IRB``, or any REPL
  # class or instance responding to a `start`` method.
  #
  # @type [Pry|Class|Object]
  attr_writer :provider

  # Console used for outputs (``stderr`` and ``stdout``)
  #
  # @type [SwagDev::Project::Tools::Console]
  attr_writer :console

  # @type [String]
  attr_writer :banner

  # Get banner
  #
  # @return [String]
  def banner
    return @banner if @banner

    patch = defined?(RUBY_PATCHLEVEL) ? "p#{RUBY_PATCHLEVEL}" : nil
    # almost like RUBY_DESCRIPTION
    descr = ["#{RUBY_ENGINE} #{RUBY_VERSION}#{patch}".rstrip,
             "(#{RUBY_RELEASE_DATE})",
             "[#{RUBY_PLATFORM}]"].join(' ')

    "{{green:#{descr}}}"
  end

  def setup
    @console ||= SwagDev.project.tools.fetch(:console)
    @provider ||= require_any(:pry) ? Pry : nil
    @banner ||= nil
  end

  # Start REPL session
  def start
    require_any(:interesting_methods)
    console.stdout.puts(banner)
    provider.start
  end

  protected

  # Get console
  #
  # @return [SwagDev::Project::Tools::Console]
  attr_reader :console

  # Get provider
  #
  # @return [Pry|Class|Object]
  attr_reader :provider

  # Require any gem based on ``Gem::Specification``
  #
  # @param [String|Symbol] spec_name
  # @param [String|Symbol] req_name
  # @return [Boolean]
  def require_any(gem_name, req_name = nil)
    gem_name = gem_name.to_s
    req_name ||= gem_name
    spec = Gem::Specification

    return false unless spec.find_all_by_name(gem_name).any?

    require req_name

    true
  end
end
