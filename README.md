This is a simple quiz to help determine if you might be at risk for Zombieism
(a growing concern in our times)

To run the quiz simply ruby lib/zombie-quiz.rb

After each question you can view a flowchart that tells you your current state.
Currently you must do the following to generate the PNG flow-chart:
* install 'dot' http://www.graphviz.org/Download..php
* run dot against the generated dot file (the file is updated after each 
question of the quiz
** dot -Tpng -ogenerated_ZombieState_workflow.png generated_ZombieState_workflow.dot

Bugs:
currently you must manually run 'dot' to generate the dot file.  calling dot
from within the program did not work for some reason.  Eventually it would be
best to use the graphviz gem to create the dot file and the graph rather than
manually creating the dot file and calling 'dot' to generate the workflow 
diagram
