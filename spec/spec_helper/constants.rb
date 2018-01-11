# frozen_string_literal: true
# -*- coding: utf-8 -*-

require 'pathname'

# @return [Pathname]
SAMPLES_PATH = ::Pathname.new(__dir__).join('..', 'samples').realpath
