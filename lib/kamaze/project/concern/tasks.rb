# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../concern'

# Concern tasks
#
# Stores tasks to enable and provides method to load them.
#
# Tasks are deignated by a string, preprocessing is applied on this strings
# before each ``task`` is required. Task prefixd by a ``@`` character are
# required without preprocessing, except first char removal.
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
  # @return [Array<String>]
  def tasks=(tasks)
    @tasks = (@tasks.to_a + tasks.to_a).map(&:to_s).map do |tn|
      if tn[0] != '@'
        { ':': '/', '-': '_' }.each do |k, v|
          tn = tn.tr(k.to_s, v)
        end
      end

      tn.to_s
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

    require tasks_ns.join('dsl/setup').to_s

    tasks.map { |task| load_task!(task) }

    self
  end

  # Load task by given name
  #
  # @param [String] task
  # @return [String]
  def load_task!(task)
    req = task[0] != '@' ? tasks_ns.join("tasks/#{task}") : task[1..-1]

    require req

    req
  end

  # Get namespace for default tasks
  #
  # @return [Pathname]
  def tasks_ns
    Pathname.new('kamaze/project')
  end
end
