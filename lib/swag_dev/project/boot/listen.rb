# frozen_string_literal: true

patchable = lambda do
  if Gem::Specification.find_all_by_name('listen').any?
    require 'listen'
    return YAML.safe_load(ENV['SILENCE_DUPLICATE_DIRECTORY_ERRORS'].to_s)
  end

  false
end

# @see https://github.com/guard/listen/wiki/Duplicate-directory-errors
#
# Listen >=2.8
# patch to silence duplicate directory errors. USE AT YOUR OWN RISK
if patchable.call
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
