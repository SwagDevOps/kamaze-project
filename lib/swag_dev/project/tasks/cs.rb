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

require 'swag_dev/project/dsl/definition'

# rubocop:disable Style/Documentation
module SwagDev::Project::Dsl::Definition
  # rubocop:enable Style/Documentation

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

  def cs_task_from_file(file)
    require 'swag_dev/project/dsl'

    type = Pathname.new(file).basename('.rb')
    sham = sham!("tasks/cs/#{type}")

    desc sham.description
    task "cs:#{type}", [:path] => sham.prerequisites do |t, args|
      patterns = project.gem.spec.require_paths
      if args[:path]
        patterns = Dir.glob(args[:path])

        raise "#{args[:path]}: does not match any files" if patterns.empty?
      end

      rubocop(patterns, sham: sham).invoke
    end
  end
end
