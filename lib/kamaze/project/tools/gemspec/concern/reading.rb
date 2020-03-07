# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../reader'
require_relative '../concern'

# Provides gemspec reader
#
# Base objects using a ``gemspec`` to obtain specification
#
# @see Kamaze::Project::Tools::Gemspec::Reader
module Kamaze::Project::Tools::Gemspec::Concern::Reading
  class << self
    def included(base)
      return if base.respond_to?(:'gemspec_reader=')

      base.class_eval <<-"ACCESSORS", __FILE__, __LINE__ + 1
        attr_writer :gemspec_reader
      ACCESSORS
    end
  end

  protected

  # @return [Kamaze::Project::Tools::Gemspec::Reader]
  def gemspec_reader
    @gemspec_reader ||= Kamaze::Project.instance.tools.fetch(:gemspec_reader)
  end

  # Get specification
  #
  # @return [Gem::Specification]
  def specification
    specification = gemspec_reader.read

    specification.define_singleton_method(:'ready?') do
      gemspec_reader.read(Hash).include?(:full_name)
    end

    specification
  end
end
