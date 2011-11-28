require "rubygems"
require "bundler/setup"
require_relative '../lib/zombie-state.rb'

describe "it should color the current state " do
  subject { ZombieState.new }

  it "should color the initial state green" do

    subject
  
  end

  it "should color the exposed state yellow" do

    subject.exposed!
    subject.exposure_level_1!
    subject.quarantine!
    subject.proto_zombie!
    subject.zombie!
  
  end


end
