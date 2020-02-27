# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../gemspec'
require_relative 'reader/decorator'

require 'pathname'
require 'rubygems'

# Read ``gemspec`` file
#
# Retrieve ``Gem::Specification`` through ``read`` method.
#
# @see Kamaze::Project
class Kamaze::Project::Tools::Gemspec::Reader
  # @return [String]
  attr_accessor :gem_name

  attr_writer :project

  def mutable_attributes
    [:project, :gem_name]
  end

  # @return [Pathname]
  def pwd
    ::Pathname.new(Dir.pwd)
  end

  # Read gemspec (as given ``type``)
  #
  # Return ``Gem::Specification`` or given ``type``
  #
  # @raise [ArgumentError] when type is not supported
  # @param [nil|Class|Symbol] type
  # @return [Gem::Specification|Object]
  def read(type = nil)
    Dir.chdir(pwd) do
      spec = Gem::Specification.load(self.spec_file.to_s)

      type ? Decorator.new(spec).to(type) : spec
    end
  end

  # Get (gem)spec file path
  #
  # @return [Pathname]
  def spec_file
    pwd.join("#{project.name}.gemspec")
  end

  # Get project
  #
  # @see Kamaze.project
  # @return [Object|Kamaze::Project]
  def project
    @project || Kamaze.project
  end

  protected

  def setup
    @gem_name ||= project.name
  end
end
