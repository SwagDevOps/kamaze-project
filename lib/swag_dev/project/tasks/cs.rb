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
  # @param [Array<String>] patterns
  # @param [Hash] options
  # @return [RuboCop::RakeTask]
  #
  # Sample of use:
  #
  # ```ruby
  # desc 'Run static code analyzer'
  # task 'cs:correct', [:path] => ['gem:gemspec'] do |t, args|
  #     rubocop(args.fetch(:path), sham: sham!).invoke
  # end
  # ```
  def rubocop(patterns, options = {})
    require 'rubocop/rake_task'
    require 'securerandom'

    tname = '%s:rubocop' % SecureRandom.hex(8)
    shammed = options[:sham] || sham!

    RuboCop::RakeTask.new(tname) do |task|
      task.options       = shammed.options
      task.patterns      = patterns
      task.fail_on_error = shammed.fail_on_error
    end

    Rake::Task[tname]
  end
end
