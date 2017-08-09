# frozen_string_literal: true

[nil, :watch].each do |req|
  require ['swag_dev/project/tasks/doc', req].join('/').gsub(%r{/$}, '')
end
