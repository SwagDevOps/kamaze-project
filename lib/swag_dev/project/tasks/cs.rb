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

# Provide rubocop method
#
# @todo convert to tools
module SwagDev::Project::Cs
  # Make a rubocop ``RakeTask``
  #
  # @param [Array<String>] patterns
  # @param [Hash] options
  #
  # Sample of use:
  #
  # ```ruby
  # desc 'Run static code analyzer'
  # task 'cs:correct', [:path] => ['gem:gemspec'] do |t, args|
  #     rubocop(args.fetch(:path), sham: sham!).invoke
  # end
  # ```
  def rubocop(patterns, *args)
    require 'rubocop/rake_task'
    require 'securerandom'

    tname = '%<task>s:rubocop' % { task: SecureRandom.hex(8) }
    patterns = Dir.glob(patterns)
    raise "#{args[:path]}: does not match any files" if patterns.empty?

    RuboCop::RakeTask.new(tname) do |task|
      task.options = args
      task.patterns = patterns
    end

    Rake::Task[tname].execute
  end
end

self.extend(SwagDev::Project::Cs)
