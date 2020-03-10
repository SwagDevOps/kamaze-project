# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

autoload(:YAML, 'yaml')
autoload(:Gem, 'rubygems')

patchable = lambda do
  if Gem::Specification.find_all_by_name('listen').any?
    require 'listen'
    return YAML.safe_load(ENV['SILENCE_DUPLICATE_DIRECTORY_ERRORS'].to_s)
  end

  false
end

# rubocop:disable all

# @see https://github.com/guard/listen/wiki/Duplicate-directory-errors
#
# Listen >=2.8
# patch to silence duplicate directory errors. USE AT YOUR OWN RISK
if patchable.call
  if Gem::Version.new(Listen::VERSION) >= Gem::Version.new('2.8.0')
    module Listen
      class Record
        class SymlinkDetector
          def _fail(_, _)
            fail Error, "Don't watch locally-symlinked directory twice"
          end
        end
      end
    end
  end
end

# rubocop:enable all
