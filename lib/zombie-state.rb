require 'workflow'
#
# "Zombie State" tracks one on the scale from human-to-zombie
# 
# Ruby Fall Project
#   Chris Larson krystoff@uw.edu
#   Andy Litzinger ajlitzin@uw.edu
#   @version 0.1
#
class ZombieState
  include Workflow
  workflow do
    state :human do
      event :exposed, :transitions_to => :exposed
      event :quarantine, :transitions_to => :quarantine
      event :infected, :transitions_to => :infected
      event :proto_zombie, :transitions_to => :proto_zombie
      event :zombie, :transitions_to => :zombie
    end
    state :exposed do
      event :risk1, :transitions_to => :risk1
      event :risk2, :transitions_to => :risk2
      event :risk3, :transitions_to => :risk3
      event :infected, :transitions_to => :infected
      event :proto_zombie, :transitions_to => :proto_zombie
      event :zombie, :transitions_to => :zombie
    end
    state :quarantine do
      event :human, :transitions_to => :human
      event :infected, :transitions_to => :infected
      event :proto_zombie, :transitions_to => :proto_zombie
      event :zombie, :transitions_to => :zombie
    end
    state :risk1 do
      event :quarantine, :transitions_to => :quarantine
      event :infected, :transitions_to => :infected
      event :proto_zombie, :transitions_to => :proto_zombie
      event :zombie, :transitions_to => :zombie
    end
    state :risk2 do
      event :quarantine, :transitions_to => :quarantine
      event :infected, :transitions_to => :infected
      event :proto_zombie, :transitions_to => :proto_zombie
      event :zombie, :transitions_to => :zombie
    end
    state :risk3 do
      event :quarantine, :transitions_to => :quarantine
      event :infected, :transitions_to => :infected
      event :proto_zombie, :transitions_to => :proto_zombie
      event :zombie, :transitions_to => :zombie
    end
    state :infected do
      event :proto_zombie, :transitions_to => :proto_zombie
      event :zombie, :transitions_to => :zombie
    end
    state :proto_zombie do
      event :zombie, :transitions_to => :zombie
    end
    state :zombie
  end
 
  def human
    puts 'human/not infected'
    # send an email or log to a file
  end

  def exposed
    puts 'exposed to zombie'
    # send an email or log to a file
  end

  def risk1
    puts 'low level of risk for infection'
  end
  
  def risk2
    puts 'moderate level of risk for infection'
  end
  
  def risk3
    puts 'high level of risk for infection'
  end
  
  def quarantine
    puts 'in quarantine for 1 week'
  end
  
  def infected
    puts 'infected with zombie virus'
  end
  
  def proto_zombie
    puts 'starting to manifest zombie traits'
  end
  
  def zombie
    puts 'full zombie phenotype'
  end
  
end
