# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../concern'

# Concern tasks
#
# Stores tasks to enable and provides method to load them
module Kamaze::Project::Concern::Tasks
  # Get tasks
  #
  # @return [Array<Symbol>]
  def tasks
    @tasks ||= []

    @tasks.clone.freeze
  end

  # Set tasks
  #
  # @param [Array] tasks
  def tasks=(tasks)
    @tasks = (@tasks.to_a + tasks.to_a).map(&:to_s).map do |tn|
      { ':': '/', '-': '_' }.each { |k, v| tn = tn.tr(k.to_s, v) }

      tn
    end.map(&:to_sym).uniq
  end

  protected

  # Load tasks
  #
  # Tasks are loaded only when ``Rake::DSL`` is defined.
  # ``DSL::Definition`` is loaded during tasks loading.
  #
  # @see Kamaze::Project::DSL::Definition
  # @return [self]
  def tasks_load!
    return self unless Kernel.const_defined?('Rake::DSL')

    require tasks_ns.join('dsl/setup')

    tasks.map { |task| tasks_ns.join("tasks/#{task}") }
         .map(&:to_s)
         .each { |req| require req }

    self
  end

  # Get namespace for default tasks
  #
  # @return [Pathname]
  def tasks_ns
    Pathname.new('kamaze/project')
  end
end
