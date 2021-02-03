# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../vagrant'
require 'pathname'
require 'yaml'

class Kamaze::Project::Tools::Vagrant
  class Writer
  end
end

# Responsible to write a ``Vagrantfile``
#
# ``Vagrantfile`` is written as a standalone, i. e. ``boxes`` variable
# is set as a base64 string. ``Vagrantfile`` defines the necessary methods
# to setup VMs from ``boxes``.
class Kamaze::Project::Tools::Vagrant::Writer
  # Template used to generate ``Vagrantfile``
  #
  # @return [::Pathname]
  attr_reader :template

  # Path to Vagrantfile
  #
  # @return [Pathname]
  attr_reader :output_file

  # @param [String] template
  # @param [String] output_file
  def initialize(template, output_file = 'Vagrantfile')
    template = ::Pathname.new(template)

    @template = template
    @template = template.join('Vagrantfile') if template.directory?
    @output_file = output_file
  end

  # Write ``Vagrantfile`` based on given ``boxes``
  #
  # @param [Hash] boxes
  def write(boxes)
    ::YAML.dump(boxes)
          .yield_self { |yaml| templatize(yaml) }
          .yield_self { |content| output_file.write(content) }
  end

  protected

  # Make content (used to write ``Vagrantfile``)
  #
  # @param [String] yaml
  # @return [String]
  def templatize(yaml)
    boxes64 = Base64.strict_encode64(yaml).yield_self do |text|
      word_wrap(text, 70).map { |s| "\s\s'#{s}'\\" }.join("\n").chomp('\\')
    end

    ['# frozen_string_literal: true',
     '# vim: ai ts=2 sts=2 et sw=2 ft=ruby', nil,
     '[:base64, :yaml, :pp].each { |req| require req.to_s }', nil,
     "cnf64 = \\\n#{boxes64}", nil,
     'boxes = YAML.safe_load(Base64.strict_decode64(cnf64), [Symbol])', nil,
     template.read.gsub(/^#.*\n/, '')]
      .map(&:to_s).join("\n").gsub(/\n\n+/, "\n\n")
  end

  # Wrap text into small chunks
  #
  # @param [String] text
  # @param [Fixnum] width
  # @return [Array<String>]
  def word_wrap(text, width = 80)
    text.each_char.each_slice(width).to_a.map(&:join)
  end
end
