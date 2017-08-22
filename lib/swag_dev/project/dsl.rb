# frozen_string_literal: true

require 'swag_dev/project'

# Namespace for DSL providing loader for DSL
#
# Sample of use:
#
# ```ruby
# require 'swag_dev/project/dsl'
# ```
#
# Extend the main object with the DSL commands.
# This allows top-level calls to ``project``, etc.
# to work from a Rakefile without polluting the object inheritance tree.
module SwagDev::Project::Dsl
end

require 'swag_dev/project/dsl/definition'

self.extend(SwagDev::Project::Dsl::Definition)
