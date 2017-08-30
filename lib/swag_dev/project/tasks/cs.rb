# frozen_string_literal: true
# A Ruby static code analyzer, based on the community Ruby style guide.
#
# @see http://batsov.com/rubocop/
# @see https://github.com/bbatsov/rubocop
#
# Share RuboCop rules across repos
# @see https://blog.percy.io/share-rubocop-rules-across-all-of-your-repos-f3281fbd71f8
# @see https://github.com/percy/percy-style
#
# ~~~~
# # .rubocop.yml
# inherit_gem:
#   percy-style: [ default.yml ]
# ~~~~

module SwagDev::Project::Dsl::Definition
  # Make a rubocop ``RakeTask``
  #
  # @param [String|Symbol] sham_name
  # @param [Array<String>] patterns
  # @return [RuboCop::RakeTask]
  #
  # Sample of use:
  #
  # ```ruby
  # desc 'Run static code analyzer'
  # task 'cs:correct', [:path] => ['gem:gemspec'] do |t, args|
  #     rubocop_from_sham('tasks/cs/correct', args.fetch(:path).invoke
  # end
  # ```
  def rubocop_from_sham(sham_name, patterns)
    require 'rubocop/rake_task'
    require 'securerandom'

    tname = '%s:rubocop' % SecureRandom.hex(8)

    RuboCop::RakeTask.new(tname) do |task|
      task.options       = sham!(sham_name).options
      task.patterns      = patterns
      task.fail_on_error = sham!(sham_name).fail_on_error
    end

    Rake::Task[tname]
  end
end
