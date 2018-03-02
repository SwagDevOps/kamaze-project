# rubocop:disable Naming/FileName
# frozen_string_literal: true
# rubocop:enable Naming/FileName

# Sample of use (``.git/hooks/pre-commit``):
#
# ```sh
# #!/usr/bin/env sh
#
# exec bundle exec rake cs:pre-commit
# ```

tools = SwagDev.project.tools

# process files (index) ----------------------------------------------
index = lambda do
  hooks = tools.fetch(:git).hooks
  hooks[:pre_commit].process_index(allow_empty: true) do |files|
    return 0 if files.reject(&:deleted?).empty?

    tools.fetch(:rubocop).prepare do |c|
      c.patterns = files.reject(&:deleted?).map(&:to_s)
    end.run
  end
end

# after process ------------------------------------------------------
after = lambda do |retcode|
  # @raise ArgumentError
  retcode = ('%<retcode>d' % { retcode: retcode }).to_i
  messages = { out: nil, err: nil }
  # rubocop:disable Style/FormatStringToken
  case retcode
  when Errno::EOPNOTSUPP::Errno
    messages[:err] = "%s\n\n" % [
      'Changed files both present in index and worktree:',
      '  (use "git reset HEAD <file>..." to unstage)',
      '  (use "git add <file>..." to update what will be committed)',
    ].join("\n")

    tools.fetch(:git).status.index.unsafe_files.each do |file|
      messages[:err] += "{{red:%smodified:\s\s\s#{file}}}\n" % ("\s" * 8)
    end
  end
  # rubocop:enable Style/FormatStringToken

  messages.each do |type, message|
    unless message.nil?
      tools.fetch(:console).public_send("std#{type}").puts(message)
    end
  end

  exit(retcode) unless retcode.zero?
end

# task ---------------------------------------------------------------
task 'cs:pre-commit' do
  index.call.yield_self { |retcode| after.call(retcode) }
end
