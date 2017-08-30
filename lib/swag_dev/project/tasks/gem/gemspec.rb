# frozen_string_literal: true

require 'swag_dev/project/dsl'
require 'swag_dev/project/tasks/gem'

desc 'Update gemspec'
task 'gem:gemspec': FileList.new(["#{project.name}.gemspec"] + sham!.files)

file "#{project.name}.gemspec": FileList.new(sham!.files) do |task|
  [:ostruct, :pathname, :gemspec_deps_gen, :tenjin]
    .each { |req| require req.to_s }

  console.stdout.writeln("Updating `#{task.name}'...", :green)

  tools = OpenStruct.new(
    deps_gen: GemspecDepsGen.new,
    template: Tenjin::Engine.new(cache: false)
  )

  files = OpenStruct.new(
    templated: project.path(sham!.template),
    generated: project.path(task.name.to_s)
  )

  spec_id = files.templated
                 .read
                 .scan(/Gem::Specification\.new\s+do\s+\|([a-z]+)\|/)
                 .flatten.fetch(0)

  context = {
    name: project.name,
    dependencies: tools.deps_gen
                       .generate_project_dependencies(spec_id).strip,
  }.merge(project.version_info)

  content = tools.template.render(files.templated.to_s, context)
  files.generated.write(content)
end
