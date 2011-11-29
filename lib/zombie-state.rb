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
class ZombieState
  include Workflow

  def self.create_workflow_diagram(klass, cur_state = nil, cur_fill_color = "white", target_dir='.', graph_options='rankdir="LR", size="7,11.6", ratio="fill"')
    workflow_name = "#{klass.name}_workflow".gsub('/', '_')
    fname = File.join(target_dir, "generated_#{workflow_name}")
    File.open("#{fname}.dot", 'w') do |file|
      file.puts %Q|
digraph #{workflow_name} {
  graph [#{graph_options}];
  node [shape=box];
  edge [len=1];
      |

      klass.workflow_spec.states.each do |state_name, state|
        unless state.name.to_s == cur_state.to_s
		  file.puts %Q{  #{state.name} [label="#{state.name}"];}
		else
		  file.puts %Q{  #{state.name} [style=filled, fillcolor=#{cur_fill_color} label="#{state.name}"];}
		end
        state.events.each do |event_name, event|
          meta_info = event.meta
          if meta_info[:doc_weight]
            weight_prop = ", weight=#{meta_info[:doc_weight]}"
          else
            weight_prop = ''
          end
          file.puts %Q{  #{state.name} -> #{event.transitions_to} [label="#{event_name.to_s}" #{weight_prop}];}
        end
      end
      file.puts "}"
      file.puts
    end
    # this call seems to fuddle windows- possibly due to path slash direction
	#`dot -Tpdf -o'#{fname}.pdf' '#{fname}.dot'`
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
