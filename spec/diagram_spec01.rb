require "rubygems"
require "bundler/setup"
require_relative '../lib/zombie-state.rb'

ZombieState.create_workflow_diagram(ZombieState)
