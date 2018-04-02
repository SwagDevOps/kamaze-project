# frozen_string_literal: true

require_relative '../concern'
require 'active_support/concern'

# Concern tasks
#
# Stores tasks to enable and provides method to load them
module SwagDev::Project::Concern::Tasks
  extend ActiveSupport::Concern

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
    @tasks = (@tasks.to_a + tasks.to_a).map do |tn|
      tn.to_s.gsub(/:+/, '/').to_sym
    end.uniq
  end

  protected

  # Load tasks
  #
  # Tasks are loaded only when ``Rake::DSL`` is defined.
  # ``DSL::Definition`` is loaded during tasks loading.
  #
  # @see SwagDev::Project::DSL::Definition
  # @return [self]
  def tasks_load!
    if Kernel.const_defined?('Rake::DSL')
      ns = Pathname.new('swag_dev/project')

      [ns.join('dsl/setup'),
       tasks.map { |task| ns.join("tasks/#{task}") }]
        .flatten.map(&:to_s).each { |req| require req }
    end

    self
  end
end
