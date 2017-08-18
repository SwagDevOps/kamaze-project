# frozen_string_literal: true

require 'swag_dev/project/dsl'
require 'swag_dev/project/tasks/gem'

namespace :gem do
  desc 'Update gemspec'
  task :gemspec do
    fname = "#{project.name}.gemspec"

    [:reenable, :invoke].each { |m| Rake::Task[fname].public_send(m) }
  end
end

file "#{project.name}.gemspec": sham!('tasks/gem/gemspec').files do
  [:ostruct, :pathname, :gemspec_deps_gen, :tenjin].each do |required|
    require required.to_s
  end

  tools = OpenStruct.new(
    deps_gen: GemspecDepsGen.new,
    template: Tenjin::Engine.new(cache: false)
  )

  files = OpenStruct.new(
    templated: project.path(sham!('tasks/gem/gemspec').template),
    generated: project.path("#{project.name}.gemspec")
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
