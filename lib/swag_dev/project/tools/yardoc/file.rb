# frozen_string_literal: true

require_relative '../yardoc'

class SwagDev::Project::Tools::Yardoc::File
  def initialize(filepath, globbing = false)
    @globbing = !!globbing
    @filepath = filepath.to_s
  end

  def paths
    proc do
      if globbing?
        Dir.glob(filepath).map { |f| ::Pathname.new(f).dirname }
      else
        [::Pathname.new(filepath).dirname]
      end
    end.call.uniq.sort.map do |f|
      ::Pathname.new(f.to_s.gsub('./', ''))
    end
  end

  def globbing?
    @globbing
  end

  def to_a
    paths
  end

  def to_s
    filepath
  end

  protected

  attr_reader :filepath
end
