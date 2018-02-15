# frozen_string_literal: true

require_relative '../status'

# Provide decoration for status
#
# Result of ``to_s``, SHOULD be similar to result obtained with:
#
# ```sh
# git status -z | sed "s/\x0/\n/g"
# ```
class SwagDev::Project::Tools::Git::Status::Decorator
  # @param [SwagDev::Project::Tools::Git::Status]
  def initialize(status)
    @status = status
  end

  def files
    files = [status.index.to_a, status.worktree.to_a].flatten.sort_by(&:to_s)

    files.reject(&:untracked?)
         .concat(files.keep_if(&:untracked?))
  end

  def to_s
    files.map { |file| "#{file.status} #{file}" }.uniq.join("\n")
  end

  protected

  # @param [SwagDev::Project::Tools::Git::Status]
  attr_reader :status
end
