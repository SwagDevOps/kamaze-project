# frozen_string_literal: true

require 'swag_dev/project/tools'

# Apply provided license on project files
#
# Samples of use:
#
# ~~~~
# Licenser.process do |process|
#    process.license  = project.version_info[:license]
#    process.patterns = ['src/bin/*', 'src/**/**.rb']
# end.apply
# ~~~~
#
# ~~~~
# Licenser.process do |process|
#     process.files += Dir.glob('src/bin/*')
# end
# ~~~~
class SwagDev::Project::Tools::Licenser
  # License chapter
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
  attr_reader   :output

  class << self
    def process(&block)
      self.new.process(&block)
    end
  end

  def initialize
    yield self if block_given?

    @patterns ||= []
    @files    ||= [] # project.spec.files.reject { |f| !f.scan(/\.rb$/)[0] }
    @license  ||= '' # project.version_info[:license_header]
  end

  # @param [Array<String>] patterns
  def patterns=(patterns)
    @files    ||= []
    @patterns ||= []

    patterns.each { |pattern| @files += Dir.glob(pattern) }
    @patterns += patterns
  end

  # @return [Array<Pathname>]
  def files
    @files.each.map { |file| Pathname.new(file) }.sort
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

  # @return [Regexp]
  def license_regexp
    /#{Regexp.quote(license)}/mi
  end

  # Apply license on processable files
  #
  # @return [self]
  def process
    yield self if block_given?

    files.each { |file| apply_license(file) }

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
