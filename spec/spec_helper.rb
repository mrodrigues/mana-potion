$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'mana-potion'
require 'pry'
require 'active_record'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
require 'support/schema'
require 'support/models'
