# frozen_string_literal: true

begin
  patch = require 'listen'
rescue LoadError
  patch = false
end

# @see https://github.com/guard/listen/wiki/Duplicate-directory-errors
#
# Listen >=2.8
# patch to silence duplicate directory errors. USE AT YOUR OWN RISK
if patch and YAML.safe_load(ENV['SILENCE_DUPLICATE_DIRECTORY_ERRORS'].to_s)
  if Gem::Version.new(Listen::VERSION) >= Gem::Version.new('2.8.0')
    # rubocop:disable all
    module Listen
      class Record
        class SymlinkDetector
          def _fail(_, _)
            fail Error, "Don't watch locally-symlinked directory twice"
          end
        end
      end
    end
    # rubocop:enable all
  end
end
