# encoding: UTF-8
require 'simple_uuid'
require 'active_model'
require 'active_support/core_ext/object'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/class/inheritable_attributes'

require File.expand_path('../../vendor/moneta/lib/moneta', __FILE__)

module Toy
  autoload :Attribute,    'toy/attribute'
  autoload :Attributes,   'toy/attributes'
  autoload :Callbacks,    'toy/callbacks'
  autoload :Dirty,        'toy/dirty'
  autoload :Persistence,  'toy/persistence'
  autoload :Store,        'toy/store'
  autoload :Validations,  'toy/validations'
  autoload :Version,      'toy/version'

  extend self
end