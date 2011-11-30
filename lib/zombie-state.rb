# UWE Ruby Fall 2011 Class
# Fall Project
#   Chris Larson krystoff@uw.edu
#   Andy Litzinger ajlitzin@uw.edu
#   @version 0.2
#
# "Zombie State" tracks subjects on the scale from human-to-zombie
# 
#
require 'workflow'
require 'graphviz'

class ZombieState
  include Workflow

  def self.create_workflow_diagram(klass, cur_state = nil, cur_fill_color = "white")
    g = GraphViz.new( :G, :type => :digraph)
    klass.workflow_spec.states.each do |state_name, state|
      unless state.name.to_s == cur_state.to_s
        #add node state.name with label state.name
	    g.add_node("#{state.name}")
      else
        # add node with above plus fill color
	    g.add_node("#{state.name}", :style => "filled", :fillcolor => cur_fill_color)
      end
      state.events.each do |event_name, event|
       # meta_info = event.meta
       # if meta_info[:doc_weight]
       #   weight_prop = ", weight=#{meta_info[:doc_weight]}"
       #  else
       #    weight_prop = ''
       # add_edge state.name, event.transitions_to label=event_name.to_s
         #g.add_edge(state.name.to_s, event.transitions_to.to_s, :label => event_name.to_s)
		 g.add_edge(state.name.to_s, event.transitions_to.to_s)
      end
	end
    #create the png
    g.output( :png => "my_zombie_state.png")
  end

  workflow do
    state :human do
      event :exposed, :transitions_to => :exposed
      #event :quarantine, :transitions_to => :quarantine
      event :infected, :transitions_to => :infected
      #event :proto_zombie, :transitions_to => :proto_zombie
      #event :zombie, :transitions_to => :zombie
    end
    state :exposed do
      event :exposure_level_1, :transitions_to => :risk_level_1
      event :exposure_level_2, :transitions_to => :risk_level_2
      event :exposure_level_3, :transitions_to => :risk_level_3
      event :quarantine, :transitions_to => :quarantine
      event :infected, :transitions_to => :infected
      event :proto_zombie, :transitions_to => :proto_zombie
      #event :zombie, :transitions_to => :zombie
    end
    state :risk_level_1 do
      event :quarantine, :transitions_to => :quarantine
      event :infected, :transitions_to => :infected
      event :proto_zombie, :transitions_to => :proto_zombie
      #event :zombie, :transitions_to => :zombie
    end
    state :risk_level_2 do
      event :quarantine, :transitions_to => :quarantine
      event :infected, :transitions_to => :infected
      event :proto_zombie, :transitions_to => :proto_zombie
      #event :zombie, :transitions_to => :zombie
    end
    state :risk_level_3 do
      event :quarantine, :transitions_to => :quarantine
      event :infected, :transitions_to => :infected
      event :proto_zombie, :transitions_to => :proto_zombie
      #event :zombie, :transitions_to => :zombie
    end
    state :quarantine do
      event :human, :transitions_to => :human
      #event :infected, :transitions_to => :infected
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
 
  attr_reader :z_scale

  def human
    puts 'human/not infected'
    @z_scale = 0
    # update_graphviz_data
    self.class.create_workflow_diagram(ZombieState, "human", "green")
  end

  def exposed
    puts 'exposed to zombie'
    @z_scale = 1
    # update_graphviz_data
	self.class.create_workflow_diagram(ZombieState, "exposed", "yellow")
  end

  def exposure_level_1
    puts 'low level of risk for infection'
    @z_scale = 3
    # update_graphviz_data
    self.class.create_workflow_diagram(ZombieState, "risk_level_1", "yellow")
  end
  
  def exposure_level_2
    puts 'moderate level of risk for infection'
    @z_scale = 5
    # update_graphviz_data
    self.class.create_workflow_diagram(ZombieState, "risk_level_2", "orange")
  end
  
  def exposure_level_3
    puts 'high level of risk for infection'
    @z_scale = 7
    # update_graphviz_data
    self.class.create_workflow_diagram(ZombieState, "risk_level_3", "magenta")
  end
  
  def quarantine
    puts 'in quarantine for 1 week'
    # z_scale is not changed until leaving quarantine
    # update_graphviz_data
    self.class.create_workflow_diagram(ZombieState, "quarantine", "magenta")
  end
  
  def infected
    puts 'infected with zombie virus'
    @z_scale = 8
    # update_graphviz_data
    self.class.create_workflow_diagram(ZombieState, "proto_zombie", "red")
  end
  
  def proto_zombie
    puts 'starting to manifest zombie traits'
    @z_scale = 9
    # update_graphviz_data
    self.class.create_workflow_diagram(ZombieState, "proto_zombie", "red")
  end
  
  def zombie
    puts 'full zombie phenotype'
    @z_scale = 10
    # update_graphviz_data
    self.class.create_workflow_diagram(ZombieState, "zombie", "red")
  end
  
  def initialize
    @z_scale = 0
    self.class.create_workflow_diagram(ZombieState, "human", "green")
      
  end
  

end
