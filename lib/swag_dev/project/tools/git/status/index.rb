# frozen_string_literal: true

require_relative 'files_array'

# rubocop:disable Style/Documentation
class SwagDev::Project::Tools::Git::Status
  class Index < FilesArray
    @type = :index
  end
end
# rubocop:enable Style/Documentation

# Represent files seen in index
class SwagDev::Project::Tools::Git::Status::Index
end
