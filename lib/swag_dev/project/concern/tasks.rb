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
  # Tasks are loaded only when ``Rake::DSL`` is defined
  #
  # @return [self]
  def tasks_load!
    if Kernel.const_defined?('Rake::DSL')
      base = Pathname.new('swag_dev/project/tasks')

      self.tasks.each { |req| require base.join(req.to_s).to_s }
    end

    self
  end
end
