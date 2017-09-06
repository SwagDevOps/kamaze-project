# frozen_string_literal: true

require 'swag_dev/project/tools'

# Apply provided license on project files
#
# Samples of use:
#
# ```ruby
# Licenser.process do |pr|
#    pr.license  = project.version_info.fetch(:license_header)
#    pr.patterns = ['bin/*', 'lib/**/**.rb']
# end
# ```
#
# ```ruby
# Licenser.process do |pr|
#     pr.files += Dir.glob('bin/*')
# end
# ```
#
# Sample of use (with DSL):
#
# ```ruby
# require 'swag_dev/project/dsl'
# require 'swag_dev/project/tools/licenser'
#
# project do |c|
#   c.working_dir = "#{__dir__}/.."
#   c.subject = SwagDev::Project
#   c.name = 'swag_dev-project'
#   c.tasks = []
# end
#
# licenser = SwagDev::Project::Tools::Licenser.process do |process|
#   process.working_dir = project.working_dir
#   process.license     = project.version_info.fetch(:license_header)
#   process.patterns    = ['bin/*', 'lib/**/**.rb']
#   process.output      = STDOUT
# end
# ```
class SwagDev::Project::Tools::Licenser
  # License chapter/header
  #
  # @return [String]
  attr_accessor :license

  # Files to be licensed
  #
  # @return [Array<Pathname>]
  attr_accessor :files

  # Patterns used to match files
  #
  # @return [Array<String>]
  attr_reader   :patterns

  # Where (default is current opened file) to write output
  #
  # @return [Pathname|IO|nil]
  attr_accessor :output

  # @return [Pathname]
  attr_accessor :working_dir

  class << self
    def process(&block)
      self.new.process(&block)
    end
  end

  def initialize
    yield self if block_given?

    @working_dir ||= Dir.pwd
    @patterns    ||= []
    @files       ||= []
    @license     ||= '' # project.version_info.fetch(:license_header)
  end

  # Get working-dir
  #
  # @return [Pathname]
  def working_dir
    Pathname.new(@working_dir || Dir.pwd)
  end

  # Set patterns
  #
  # @param [Array<String>] patterns
  def patterns=(patterns)
    @files    ||= []
    @patterns ||= []

    patterns.each do |pattern|
      @files += Dir.glob(working_dir.join(pattern))
    end

    @patterns += patterns
  end

  # Get files
  #
  # @return [Array<Pathname>]
  def files
    @files.map { |file| Pathname.new(file) }
          .delete_if { |file| !file.file? }
          .delete_if { |file| file.basename.to_s[0] == '.' }
          .sort.uniq
          .map { |file| file.realpath }
  end

  # Get license, formatted (using comments)
  #
  # @return [String]
  def license
    @license.to_s.gsub(/\n{3}/mi, "\n\n").lines.map do |line|
      line.chomp!

      line = "# #{line}" if line and line[0] != '#'
    end.join("\n")
  end

  # Get license regexp
  #
  # @return [Regexp]
  def license_regexp
    /#{Regexp.quote(license)}/mi
  end

  # Apply license on processable files
  #
  # @return [self]
  def process
    yield self if block_given?

    files.each do |file|
      apply_license(file)
    end

    self
  end

  protected

  # Get an index, skipping comments
  #
  # @param [Array<String>] lines
  # @return [Fixnum]
  def index_lines(lines)
    index = 0
    loop do
      break unless lines[index] and lines[index][0] == '#'

      index += 1
    end

    index
  end

  # Apply license on a file
  #
  # @param [Pathname] file
  # @return [Pathname] file
  def apply_license(file)
    content    = file.read
    licensable = !content.scan(license_regexp)[0] and !license.strip.empty?

    if licensable
      content = license_lines(content.lines).join('')

      (output || file).write(content)
    end

    file
  end

  # Apply license on lines
  #
  # @param [Array<String>] lines
  # @return [Array<String>] with license applied
  def license_lines(lines)
    index = index_lines(lines)
    lines = lines.clone

    return lines if index <= 0

    lines[0..index] + license.lines + ["\n"] + lines[index..-1]
  end
end
