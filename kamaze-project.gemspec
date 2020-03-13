# frozen_string_literal: true
# vim: ai ts=2 sts=2 et sw=2 ft=ruby
# rubocop:disable all

Gem::Specification.new do |s|
  s.name        = "kamaze-project"
  s.version     = "1.1.0"
  s.date        = "2020-02-24"
  s.summary     = "Automatize recurrent dev tasks"
  s.description = "A bunch of (rake) tasks to automatize development workflows."

  s.licenses    = ["GPL-3.0"]
  s.authors     = ["Dimitri Arrigoni"]
  s.email       = "dimitri@arrigoni.me"
  s.homepage    = "https://github.com/SwagDevOps/kamaze-project"

  # MUST follow the higher required_ruby_version
  # requires version >= 2.3.0 due to safe navigation operator &
  # requires version >= 2.5.0 due to yield_self
  s.required_ruby_version = ">= 2.5.0"
  s.require_paths = ["lib"]
  s.files         = [
    ".yardopts",
    "lib/kamaze-project.rb",
    "lib/kamaze/project.rb",
    "lib/kamaze/project/autoload.rb",
    "lib/kamaze/project/boot/core_ext.rb",
    "lib/kamaze/project/boot/listen.rb",
    "lib/kamaze/project/bundled.rb",
    "lib/kamaze/project/concern.rb",
    "lib/kamaze/project/concern/cli.rb",
    "lib/kamaze/project/concern/cli/with_exit_on_failure.rb",
    "lib/kamaze/project/concern/env.rb",
    "lib/kamaze/project/concern/helper.rb",
    "lib/kamaze/project/concern/mode.rb",
    "lib/kamaze/project/concern/observable.rb",
    "lib/kamaze/project/concern/sh.rb",
    "lib/kamaze/project/concern/tasks.rb",
    "lib/kamaze/project/concern/tools.rb",
    "lib/kamaze/project/config.rb",
    "lib/kamaze/project/core_ext/object.rb",
    "lib/kamaze/project/core_ext/pp.rb",
    "lib/kamaze/project/debug.rb",
    "lib/kamaze/project/dsl.rb",
    "lib/kamaze/project/dsl/definition.rb",
    "lib/kamaze/project/dsl/setup.rb",
    "lib/kamaze/project/helper.rb",
    "lib/kamaze/project/helper/inflector.rb",
    "lib/kamaze/project/helper/project.rb",
    "lib/kamaze/project/helper/project/config.rb",
    "lib/kamaze/project/observable.rb",
    "lib/kamaze/project/observer.rb",
    "lib/kamaze/project/resources/Vagrantfile",
    "lib/kamaze/project/resources/config/tools.yml",
    "lib/kamaze/project/struct.rb",
    "lib/kamaze/project/tasks/cs.rb",
    "lib/kamaze/project/tasks/cs/control.rb",
    "lib/kamaze/project/tasks/cs/correct.rb",
    "lib/kamaze/project/tasks/cs/pre_commit.rb",
    "lib/kamaze/project/tasks/doc.rb",
    "lib/kamaze/project/tasks/doc/watch.rb",
    "lib/kamaze/project/tasks/gem.rb",
    "lib/kamaze/project/tasks/gem/build.rb",
    "lib/kamaze/project/tasks/gem/compile.rb",
    "lib/kamaze/project/tasks/gem/gemspec.rb",
    "lib/kamaze/project/tasks/gem/install.rb",
    "lib/kamaze/project/tasks/gem/push.rb",
    "lib/kamaze/project/tasks/misc/gitignore.rb",
    "lib/kamaze/project/tasks/shell.rb",
    "lib/kamaze/project/tasks/sources.rb",
    "lib/kamaze/project/tasks/sources/license.rb",
    "lib/kamaze/project/tasks/test.rb",
    "lib/kamaze/project/tasks/vagrant.rb",
    "lib/kamaze/project/tasks/version/edit.rb",
    "lib/kamaze/project/tools.rb",
    "lib/kamaze/project/tools/base_tool.rb",
    "lib/kamaze/project/tools/console.rb",
    "lib/kamaze/project/tools/console/output.rb",
    "lib/kamaze/project/tools/console/output/buffer.rb",
    "lib/kamaze/project/tools/gemspec.rb",
    "lib/kamaze/project/tools/gemspec/builder.rb",
    "lib/kamaze/project/tools/gemspec/concern.rb",
    "lib/kamaze/project/tools/gemspec/concern/reading.rb",
    "lib/kamaze/project/tools/gemspec/packager.rb",
    "lib/kamaze/project/tools/gemspec/packer.rb",
    "lib/kamaze/project/tools/gemspec/packer/command.rb",
    "lib/kamaze/project/tools/gemspec/reader.rb",
    "lib/kamaze/project/tools/gemspec/reader/decorator.rb",
    "lib/kamaze/project/tools/gemspec/writer.rb",
    "lib/kamaze/project/tools/gemspec/writer/dep_gen.rb",
    "lib/kamaze/project/tools/gemspec/writer/dependency.rb",
    "lib/kamaze/project/tools/git.rb",
    "lib/kamaze/project/tools/git/hooks.rb",
    "lib/kamaze/project/tools/git/hooks/base_hook.rb",
    "lib/kamaze/project/tools/git/hooks/pre_commit.rb",
    "lib/kamaze/project/tools/git/status.rb",
    "lib/kamaze/project/tools/git/status/decorator.rb",
    "lib/kamaze/project/tools/git/status/file.rb",
    "lib/kamaze/project/tools/git/status/files_array.rb",
    "lib/kamaze/project/tools/git/status/index.rb",
    "lib/kamaze/project/tools/git/status/worktree.rb",
    "lib/kamaze/project/tools/git/util.rb",
    "lib/kamaze/project/tools/licenser.rb",
    "lib/kamaze/project/tools/packager.rb",
    "lib/kamaze/project/tools/packager/filesystem.rb",
    "lib/kamaze/project/tools/packager/filesystem/operator.rb",
    "lib/kamaze/project/tools/packager/filesystem/operator/utils.rb",
    "lib/kamaze/project/tools/process_locker.rb",
    "lib/kamaze/project/tools/rspec.rb",
    "lib/kamaze/project/tools/rubocop.rb",
    "lib/kamaze/project/tools/rubocop/arguments.rb",
    "lib/kamaze/project/tools/rubocop/config.rb",
    "lib/kamaze/project/tools/shell.rb",
    "lib/kamaze/project/tools/vagrant.rb",
    "lib/kamaze/project/tools/vagrant/composer.rb",
    "lib/kamaze/project/tools/vagrant/composer/file.rb",
    "lib/kamaze/project/tools/vagrant/remote.rb",
    "lib/kamaze/project/tools/vagrant/shell.rb",
    "lib/kamaze/project/tools/vagrant/writer.rb",
    "lib/kamaze/project/tools/yardoc.rb",
    "lib/kamaze/project/tools/yardoc/file.rb",
    "lib/kamaze/project/tools/yardoc/watchable.rb",
    "lib/kamaze/project/tools/yardoc/watcher.rb",
    "lib/kamaze/project/tools_provider.rb",
    "lib/kamaze/project/tools_provider/resolver.rb",
    "lib/kamaze/project/version.rb",
    "lib/kamaze/project/version.yml",
  ]

  s.add_runtime_dependency("cli-ui", ["~> 1.3"])
  s.add_runtime_dependency("cliver", ["~> 0.3"])
  s.add_runtime_dependency("dotenv", ["~> 2.7"])
  s.add_runtime_dependency("dry-inflector", ["~> 0.1"])
  s.add_runtime_dependency("kamaze-version", ["~> 1.0"])
  s.add_runtime_dependency("process_lock", ["~> 0.1"])
  s.add_runtime_dependency("rake", ["~> 13.0"])
  s.add_runtime_dependency("rugged", ["~> 0.28"])
  s.add_runtime_dependency("tenjin", ["~> 0.7"])
  s.add_runtime_dependency("tty-editor", ["~> 0.5"])
  s.add_runtime_dependency("tty-screen", [">= 0.6.2", "~> 0.7"])
end

# Local Variables:
# mode: ruby
# End:
