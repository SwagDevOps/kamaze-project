# swag_dev-project

This gem is intended to provide a bunch of recurrent dev tasks, such as:

* packaging (``gem``, ``rubyc``)
* running automated tests (``rspec``)
* generating documentation (``yardoc``)
* checking and/or correcting coding style (``rubocop``)
* running virtual machines (``vagrant``)

and so on.

Automation mostly relies on the ``gem`` (and ``gemspec``) standards,
most tasks MUST run in a sufficient gem context.

## Ease of use

This gem keeps ease of use (and DRY) in mind.

Sample of use:

```ruby
require 'swag_dev/project'

SwagDev.project do |c|
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
export PROJECT_NAME='swag_dev-project
```

When ``project`` name is defined, on instantiation, the ``PROJECT_NAME``
environment variable is ignored, and has no effect.
Furthermore a ``mode`` SHOULD be defined, using environment:

```sh
export PROJECT_MODE='development'
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

[rubygems/specification#name]: http://guides.rubygems.org/specification-reference/#name
[guard/listen#issues-limitations]: https://github.com/guard/listen/blob/d43cbd510ef151b9365bb9c421ef62496260d3fa/README.md#issues--limitations
