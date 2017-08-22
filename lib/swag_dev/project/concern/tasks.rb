# frozen_string_literal: true

require 'swag_dev/project/concern'
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
    (@tasks = @tasks || []).clone
  end

  # Set tasks
  #
  # @param [Array] tasks
  def tasks=(tasks)
    tasks = tasks.to_a
    @tasks ||= []

    @tasks.empty? ? @tasks = tasks : @tasks += tasks
    @tasks.map!(&:to_sym).uniq!

    tasks
  end

  protected

  # Load tasks
  #
  # Tasks are loaded only if ``Rake::DSL`` is defined
  #
  # @return [self]
  def tasks_load!
    if Kernel.const_defined?('Rake::DSL')
      self.tasks.each do |req|
        require "swag_dev/project/tasks/#{req}"
      end
    end

    self
  end
end
