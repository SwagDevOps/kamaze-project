# frozen_string_literal: true
# A Ruby static code analyzer, based on the community Ruby style guide.
#
# @see http://batsov.com/rubocop/
# @see https://github.com/bbatsov/rubocop
#
# Share RuboCop rules across repos
# @see https://blog.percy.io/share-rubocop-rules-across-all-of-your-repos-f3281fbd71f8
# @see https://github.com/percy/percy-style
#
# ~~~~
# # .rubocop.yml
# inherit_gem:
#   percy-style: [ default.yml ]
# ~~~~

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

[:control, :correct].each { |req| require_relative "cs/#{req}" }
