# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../composer'
require 'pathname'

class Kamaze::Project::Tools::Vagrant::Composer
  class File < ::Pathname
  end
end

# Describe a file
#
# File can be overriden (``.override.yml``). A file has a name.
# It is loadable.
class Kamaze::Project::Tools::Vagrant::Composer::File
  # @return [String]
  def name
    self.basename('.yml').to_s
  end

  # Get path to potential override
  def override
    self.dirname.join("#{name}.override.yml")
  end

  # Denote file is empty
  #
  # Return ``true`` when content is empty
  #
  # @return [Boolean]
  def empty?
    self.read.empty?
  end

  # Denote file is loadable
  #
  # This test is based on filesystem and emptyness
  #
  # @return [Boolean]
  def loadable?
    self.file? and self.readable? and !self.empty?
  end

  # Denote file is overriden
  #
  # @return [Booolean]
  def overriden?
    override.file? and override.readable?
  end

  # Load file
  #
  # @return [Hash]
  def load
    return nil unless self.loadable?

    data = yaml_read(self)
    data.merge!(yaml_read(override)) if overriden?

    data
  end

  protected

  # Read a file (by given path)
  #
  # Use ``safe_load`` on file content
  #
  # @param [Pathname] path
  def yaml_read(path)
    YAML.safe_load(path.read, [Symbol])
  end
end
