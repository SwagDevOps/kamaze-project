# swag_dev-project

This gem is intended to provide a bunch of recurrent dev tasks, such as:
packaging (``gem``, ``rubyc``),
running automated tests (``rspec``),
generating documentation (``yardoc``),
checking and/or correcting coding style (``rubocop``),
running virtual machines (``vagrant``),
and so on.

## Ease of use

This gem keeps ease of use in mind.

Sample of use:

```ruby
require 'swag_dev/project/dsl'

project do |c|
  c.subject = SwagDev::Project
  c.name    = :'swag_dev-project'
  c.tasks   = [
    :'cs:correct', :'cs:control',
    :doc, :'doc:watch',
    :gem, :'gem:compile',
    :shell,
    :'sources:license',
    :test,
    :'version:edit',
  ]
end
```

A ``project`` has a __name__ and a __subject__.
Project [name](http://guides.rubygems.org/specification-reference/#name)
SHOULD be the same as the name of the (eventually) generated gem package.

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
export PROJECT_NAME='swag_dev-project
```

When ``project`` name is defined, on instantiation, the ``PROJECT_NAME``
environment variable is ignored, and has no effect.
Furthermore a ``mode`` SHOULD be defined, using environment:

```sh
export PROJECT_MODE='development'
```

## Dependencies (``gems``)

Some dependencies are considered as optional, as seen inspecting the
``gems.rb`` file.
For example, ``rspec`` is considered as a ``development`` dependency
of this gem, but ``rspec`` is required by the ``test`` task.
The ``listen`` gem is optional, this gem is only used for "``watch`` tasks"
and has [several system incompatibilities](https://github.com/guard/listen/blob/d43cbd510ef151b9365bb9c421ef62496260d3fa/README.md#issues--limitations).
