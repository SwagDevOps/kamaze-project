# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# Sample of use (``.git/hooks/pre-commit``):
#
# ```sh
# #!/usr/bin/env sh
#
# exec bundle exec rake cs:pre-commit
# ```

# process files (index) ----------------------------------------------
process = lambda do
  hook = tools.fetch(:git).hooks[:pre_commit]

  hook.process_index(allow_empty: true) do |files|
    return nil if files.reject(&:deleted?).empty?

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
      tools.fetch(:console).public_send("std#{type}").puts(message + "\n")
    end
  end

  exit(retcode) unless retcode.zero?
end

# task ---------------------------------------------------------------
task 'cs:pre-commit' do
  begin
    process.call
  rescue SystemExit => e
    after.call(e.status)
  end
end
