# frozen_string_literal: true

# Namespace for DSL
module SwagDev::Project::Dsl
end

require 'swag_dev/project/dsl/definition'

# Extend the main object with the DSL commands. This allows top-level
# calls to ``project``, etc. to work from a Rakefile without polluting the
# object inheritance tree.
self.extend(SwagDev::Project::Dsl::Definition)
