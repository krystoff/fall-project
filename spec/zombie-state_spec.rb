require "rubygems"
require "bundler/setup"
require 'simplecov'
SimpleCov.start
require File.expand_path(File.dirname(__FILE__) + '/../lib/zombie-state.rb')

describe "states" do

  subject { ZombieState.new } 

  it "should start human" do
    subject.current_state.to_s.should == "human"
  end

  it "should start with a z_scale of zero" do
    subject.z_scale.should == 0
  end

  context "when exposed to a zombie" do
    it "should be exposed" do
      subject.exposed!
      subject.current_state.to_s.should == "exposed"
    end
    it "should not be able to transition back to human when exposed" do
      expect { subject.human! }.to raise_error
    end
    it "should tell us it is exposed" do
      expect { subject.exposed!}.to_s == "exposed to zombie"
    end
    it "available events should be exposure_level_1, exposure_level_2, exposure_level_3, infected, proto-zombie" do
      subject.exposed!
      subject.current_state.events.should have_key(:exposure_level_1)
      subject.current_state.events.should have_key(:exposure_level_2)
      subject.current_state.events.should have_key(:exposure_level_3)
      subject.current_state.events.should have_key(:infected)
      subject.current_state.events.should have_key(:proto_zombie)
      subject.current_state.events.keys.should == [:exposure_level_1,:exposure_level_2,:exposure_level_3,:infected,:proto_zombie]
    end
  end
  
  context "when infected" do
    it "should be infected" do
      subject.infected!
      subject.infected?.should == true
      subject.current_state.to_s.should == "infected"
    end
    it "should not be able to transition back to human when exposed" do
      expect { subject.human! }.to raise_error
    end
    it "should tell us it is infected" do
      expect { subject.infected!}.to_s == "infected with zombie virus"
    end
    it "can be transitioned to zombie" do
      subject.infected!
      subject.zombie!
      subject.current_state.to_s.should == "zombie"
    end
    it "available events should be proto_zombie and zombie" do
      subject.infected!
      subject.current_state.events.should have_key(:zombie)
      subject.current_state.events.should have_key(:proto_zombie)
      subject.current_state.events.keys.sort.should == [:zombie,:proto_zombie].sort
    end
  end

  context "when zombie" do
    it "should be zombie" do
      subject.infected!
      subject.zombie!
      subject.current_state.to_s.should == "zombie"
    end
  end

  
end
