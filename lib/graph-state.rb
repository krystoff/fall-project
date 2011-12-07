# UWE Ruby Fall 2011 Class
# Fall Project
#   Chris Larson krystoff@uw.edu
#   Andy Litzinger ajlitzin@uw.edu
#   @version 0.2
#
# "Graph State" creates/updates a plot based on zombie-state.rb and zombie-quiz.rb responses
# 
#
require 'graphviz'

class GraphState

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
end
