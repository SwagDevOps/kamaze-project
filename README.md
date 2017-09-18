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
Project name SHOULD be the same as the name of the (eventually)
generated gem package.

## Environment

When ``project`` is instantiated,
a ``dotenv`` (``.env``) file can be read, evaluated and loaded.
This could be useful to set specific environment variables,
such as automake's flag variables:

```sh
export CPPFLAGS='-P'
```

On the other hand, ``.env`` file COULD define the ``project`` name:

```sh
export PROJECT_NAME='swag_dev-project
```

When ``project`` name is defined on instantiation this environment variable
is ignored, and has no effect. Furthermore a ``mode`` SHOULD be defined,
using environment:

```sh
export PROJECT_MODE='development'
```
