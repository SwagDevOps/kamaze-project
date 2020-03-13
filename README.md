# kamaze-project

This gem is intended to provide a bunch of recurrent dev tasks, such as:

* packaging (``gem``, ``rubyc``)
* running automated tests (``rspec``)
* generating documentation (``yardoc``)
* checking and/or correcting coding style (``rubocop``)
* running virtual machines (``vagrant``)

and so on.

Automation mostly relies on the ``gem`` (and ``gemspec``) standards,
most tasks SHOULD run in a sufficient gem context.

## Install

```ruby
gem 'rake', '~> 13.0'
gem 'kamaze-project', '~> 1.0'
```

```sh
gem install kamaze-project
```

## Ease of use

This gem keeps ease of use (and DRY) in mind.

Sample of use:

```ruby
require 'kamaze/project'

Kamaze::Project.instance do |project|
  project.subject = Kamaze::Project
  project.name    = :'kamaze-project'
  project.tasks   = [
    'cs:correct', 'cs:control', 'cs:pre-commit',
    'doc', 'doc:watch', 'gem', 'gem:compile',
    'shell', 'sources:license', 'test', 'version:edit',
  ]
end.load!
```

A ``project`` has a __name__ and a __subject__.
Project ``name`` SHOULD be the same as the name of the (eventually)
generated gem package [name][rubygems/specification#name].

## Environment

When ``project`` is instantiated,
a ``dotenv`` (``.env``) file CAN be read, evaluated and loaded.
This could be useful to set specific environment variables,
such as automake's flag variables:

```sh
export CPPFLAGS='-P'
```

On the other hand, ``.env`` file COULD define the ``project`` name:

```sh
export PROJECT_NAME='kamaze-project'
```

When ``project`` name is defined, on instantiation, the ``PROJECT_NAME``
environment variable is ignored, and has no effect.
Furthermore a ``mode`` SHOULD be defined, using environment:

```sh
export PROJECT_MODE='development'
```

## Tools

``Kamaze::Project`` provides several ``tools``. Tools are aimed to afford
easy-to-use and agnostic integration (with low dependency to ``rake``)
of tools such as ``gem``, ``rubocop``, ``rspec`` or ``yardoc``.
Some ``cli`` tools integrations, when it is not possible to do otherwise,
are also provided; such as ``rubyc`` or ``vagrant``.

Furthermore, adding a new tool is really easy.

```ruby
require 'kamaze/project'

class AwesomeTool < Kamaze::Project::Tools::BaseTool
  def run
    # do something awesome
  end
end

Kamaze::Project.instance do |project|
  # initialization (as seen above)

  project.tools = {
    awesome: AwesomeTool,
  }
end.load!

# your tool is accessible (through DSL):
tools.fetch(:awesome)
```

## Dependencies (``gems``)

Some dependencies are optional, as seen inspecting the
``gems.rb`` file.

For example, ``rspec`` is considered as a ``development`` dependency,
but ``rspec`` is required by the ``test`` task.
The ``listen`` gem is optional, due to
[several system incompatibilities][guard/listen#issues-limitations];
``listen`` gem is only used by some "``watch`` optional tasks".

### Troubles with ``rugged`` gem

Some dependencies are required to install ``rugged`` with native extensions:

* ``make`` or ``gmake``
* ``cmake``
* ``pkg-config``
* ``libssl-dev`` (asked for OpenSSL TLS backend)

depending on Linux distributions, and/or package managers,
dependency names are likely to change.


<!-- hyperlinks -->

[rubygems/specification#name]: http://guides.rubygems.org/specification-reference/#name
[guard/listen#issues-limitations]: https://github.com/guard/listen/blob/d43cbd510ef151b9365bb9c421ef62496260d3fa/README.md#issues--limitations
