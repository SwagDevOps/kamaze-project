# frozen_string_literal: true

require_relative '../hooks'
require_relative 'base_hook'

class SwagDev::Project::Tools::Git::Hooks
  class PreCommit < BaseHook
  end
end

# PreCommit hook
#
# Provide helper methods intended to write hooks relating to pre-commit
#
# Sample of use:
#
# ```ruby
# retcode = tools.fetch(:git).hooks[:pre_commit].process_index do |files|
#   tools.fetch(:rubocop).prepare do |c|
#     c.patterns = files.reject(&:deleted?).map(&:to_s)
#   end.run
#
#   exit(retcode) unless retcode.zero?
# end
# ```
class SwagDev::Project::Tools::Git::Hooks::PreCommit
  # Process index (files)
  #
  # Returns a status code, SHOULD return ``0`` on success,
  # any other value SHOULD denote a error.
  #
  # | code    | constant              | reason          |
  # |---------|-----------------------|-----------------|
  # | ``125`` | ``Errno::ECANCELED``  | Index is empty  |
  # | ``95``  | ``Errno::EOPNOTSUPP`` | Index is unsafe |
  # | ``0``   | ``Errno::NOERROR``    | Success         |
  #
  # @param [Hash] options
  # @option options [Boolean] :allow_unsafe
  #     Unsafe index is processed (``false``)
  # @option options [Boolean] :allow_empty
  #     Empty index is processed (``false``)
  # @yield [Array<SwagDev::Project::Tools::Git::Status::File>]
  # @yieldreturn [Fixnum]
  # @return [Fixnum]
  def process_index(options = {})
    index = options[:index] || repository.status.index
    { empty: Errno::ECANCELED, unsafe: Errno::EOPNOTSUPP }.each do |type, v|
      key = "allow_#{type}".to_sym
      options[key] = options.keys.include?(key) ? !!options[key] : false

      next if options[key]
      return v.const_get(:Errno) if index.public_send("#{type}?")
    end

    block_given? ? yield(index.to_a.freeze) : Errno::NOERROR::Errno
  end
end
