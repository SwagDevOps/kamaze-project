# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../tools'

# Provide a REPL (based on ``Pry``)
class Kamaze::Project::Tools::Shell < Kamaze::Project::Tools::BaseTool
  # REPL provider
  #
  # Allowing to replace ``Pry`` by ``IRB``, or any REPL
  # class or instance responding to a `start`` method.
  #
  # @type [Pry|Class|Object]
  attr_writer :provider

  # Console used for outputs (``stderr`` and ``stdout``)
  #
  # @type [Kamaze::Project::Tools::Console]
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
    @console ||= Kamaze.project.tools.fetch(:console)
    @provider ||= require_any(:pry) ? Object.const_get(:Pry) : nil
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
  # @return [Kamaze::Project::Tools::Console]
  attr_reader :console

  # Get provider
  #
  # @return [Pry|Class|Object]
  attr_reader :provider

  # Require any gem based on ``Gem::Specification``
  #
  # @param [String|Symbol] gem_name
  # @param [Array|nil] requirements
  # @return [Boolean]
  def require_any(gem_name, requirements = nil)
    gem_name = gem_name.to_s
    requirements ||= [gem_name]

    return false unless Gem::Specification.find_all_by_name(gem_name).any?

    requirements.each { |req| require req.to_s }

    true
  end
end
