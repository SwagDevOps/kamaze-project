# rubocop:disable Naming/FileName
# frozen_string_literal: true
# rubocop:enable Naming/FileName

require_relative '../cs'
require 'open3'

# Sample of use (``.git/hooks/pre-commit``):
#
# ```sh
# #!/usr/bin/env sh
#
# exec bundle exec rake cs:pre-commit
# ```

task 'cs:pre-commit' do
  files = Open3.capture3('git', 'status', '--porcelain', '-uno')[0]
               .to_s.lines.map(&:chomp)
               .keep_if { |line| /^(M|A)/.match(line) }
               .map { |line| line.gsub(/^[A-Z]+\s+/, '') }

  SwagDev.project.tools.fetch(:rubocop).prepare do |c|
    c.patterns = files
    c.options = ['--parallel']
  end.run
end
