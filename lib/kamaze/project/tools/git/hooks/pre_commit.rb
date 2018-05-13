# frozen_string_literal: true

require_relative '../hooks'
require_relative 'base_hook'

class Kamaze::Project::Tools::Git::Hooks
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
class Kamaze::Project::Tools::Git::Hooks::PreCommit
  # Process index (files)
  #
  # Exits with a status code, raising ``SystemExit``.
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
  # @yield [Array<Kamaze::Project::Tools::Git::Status::File>]
  # @yieldreturn [Fixnum]
  # @raise [SystemExit]
  #
  # ``:allow_empty`` and ``:allow_unsafe`` options are available,
  # to continue processing even if ``empty`` or ``unsafe``.
  def process_index(options = {})
    index = _process_index(repository.status.index, options)
    self.retcode = Errno::NOERROR::Errno

    yield(index.to_a.freeze) if block_given?
  end

  protected

  # @param [Kamaze::Project::Tools::Git::Status::Index] index
  # @param [Hash] options
  # @raise [SystemExit]
  #
  # @return [Kamaze::Project::Tools::Git::Status::Index]
  def _process_index(index, options = {})
    { empty: Errno::ECANCELED, unsafe: Errno::EOPNOTSUPP }.each do |type, v|
      with_exit_on_failure do
        key = "allow_#{type}".to_sym
        options[key] = options.keys.include?(key) ? !!options[key] : false

        next if options[key]
        self.retcode = v.const_get(:Errno) if index.public_send("#{type}?")
      end
    end

    index
  end
end
