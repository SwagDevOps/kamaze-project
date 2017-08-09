# frozen_string_literal: true

require 'swag_dev/project'
require 'swag_dev/project/tasks/gem'
require 'rake/clean'

project      = SwagDev.project
template     = 'gemspec.tpl'
dependencies = [template] + (project.gem.spec&.files).to_a

file "#{project.name}.gemspec": FileList.new(*dependencies) do
  [:ostruct, :pathname, :gemspec_deps_gen, :tenjin].each do |required|
    require required.to_s
  end

  tools = OpenStruct.new(
    deps_gen: GemspecDepsGen.new,
    template: Tenjin::Engine.new(cache: false)
  )

  files = OpenStruct.new(
    templated: Pathname.new(template),
    generated: Pathname.new(Dir.pwd).join("#{project.name}.gemspec")
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
