# UWE Ruby Fall 2011 Class
# Fall Project
#   Chris Larson krystoff@uw.edu
#   Andy Litzinger ajlitzin@uw.edu
#   @version 0.1
#
#

require 'rubygems'
require 'highline/import'
require File.expand_path(File.dirname(__FILE__) + '/../lib/zombie-state.rb')

debug = 1

print "\nWelcome to the 'Am I a Zombie' self-assessment test.\n\n"
print "**Help stop the terror from spreading, please answer the following questions honestly.**\n\n"
sleep 3 unless debug

puts "  First the good news:  if you are reading this and have concerns about whether you are a zombie or not "
puts "(i.e. you are not wholy concerned with an insatiable desire for brains!), then there is still hope.  "
puts "You may not be infected or you may be able to end your life before the infection fully takes hold. :)"
puts

#q1 = ask("Have you been in contact with a zombie?  ") {
#  |ans| ans.default = 'Yes'
#  ans.validate = /Y|y|Yes|yes|N|n|No|no/i
#}

sleep 5 unless debug

done = nil
until done
  risk = 0
  subject = ZombieState.new
  
  ## Question 1
  choose do |q1|
    puts "Have you been in contact with a zombie?  "
    q1.choice(:Yes) do |choice|
      ## risk level-1
      print "Yes?  Well, no surprise, they are taking over, so let's see how much exposure you've had.\n\n"
      risk += 2
      subject.exposed!
      sleep 3 unless debug
      print "**[Debug] End-of-Q1:  Z-scale = #{subject.z_scale}\n" if debug
      
      ## Question 2
      choose do |q2|
        puts "Were you grabbed, groped, drooled on, or worse?  "
        q2.choice(:Yes) do |choice|
          ## risk level-1-3
          print "Yes again...  Hmmmm, that's worrisome.  Maybe you got off lucky.\n\n"
          sleep 3 unless debug
  
          ## Question 3
          choose do |q3| 
            puts "Have any of the following happened to you?  "
            q3.choice('Splashed with zombie bodily fluids.') do |choice|
              ## risk level-2
              print "Uggghh.  Stinks doesn't it.  Use lots of bleach and you probably be OK.\n\n"
              risk += 2
              subject.exposure_level_2!
              sleep 3 unless debug
              
            end
            
            q3.choice('Zombie bodily fluids got into my open wounds.') do |choice|
              ## risk level-3
              print "Bad Luck.  You are at risk for being a zombie.  Use lots of bleach and scrub vigorously!\n\n"
              risk += 4
              subject.exposure_level_3!
              sleep 3 unless debug
              
            end
            
            q3.choice('Zombie bodily fluids got into my mouth.') do |choice|
              ## risk level-3
              print "Double Yuck!  That's very gross!  You didn't swallow, did you?!  Gargling with bleach may help if you didn't...\n\n"
              risk += 4
              subject.exposure_level_3!
              sleep 3 unless debug
              
            end
            
            q3.choice("I've been bitten by a zombie.") do |choice|
              ## risk level-4
              print "Very Bad Luck!  Sorry buddy, but you will almost certainly be a zombie.\n\n"
              risk += 6
              subject.infected!
              sleep 3 unless debug
              
            end
            
            q3.choice("None of the above.") do |choice|
              ## stays at risk level-1
              print "Just had a scuffle, but got away?  Good cardio works!\n\n"
              subject.exposure_level_1!
              sleep 3 unless debug
              
            end            
          end
          print "**[Debug] End-of-Q3:  Z-scale = #{subject.z_scale}\n" if debug
          
        end
            
        q2.choice(:No) do |choice|
          ## risk level-1
          print "No?  Great!  You're probably fine then.\n\n"
          # no change in subject state
          sleep 3 unless debug
          
        end
      end
    end
    
    q1.choice(:No) do |choice|
      ## risk level-0
      print "No...  Uhhh, OK.  Are you sure you need to take this test?  Oh, right, you may not remember what happened.\n\n"
      # no change in subject status
      sleep 3 unless debug
      
    end
  end
    
  print "OK, just one more question.\n\n"
  sleep 3 unless debug
  
  ## Question 4
  z_result = 'no change'
  choose do |q4|
    ## phenotype test
    puts "How do you feel about eating human brains?  "
    puts "  Please ponder this question carefully and answer as honestly as you can..."
    
    sleep 3 unless debug
    
    q4.choice("It disgusts me.") do |choice|
      ## possibly infected, but not expressing any signs yet
      print "Good.  That's very good.\n\n"
      
      if subject.z_scale >= 8
        # no change in subject state        
      elsif subject.z_scale >= 3
        z_result = 'quarantine'        
      else
        z_result = 'let go'        
      end
    end
    
    q4.choice("If seasoned properly it might be ok.") do |choice|
      ## could be ok, but best to classify as proto-zombie to be safe
      print "Hmmmm, maybe you just have strange culinary interests.\n\n"
      
      if subject.z_scale == 8
        z_result = 'proto_zombie'        
      elsif subject.z_scale >= 1
        z_result = 'quarantine'        
      else
        z_result = 'let go'        
      end
    end
  
    q4.choice("It is strangely compelling.") do |choice|
      ## proto-zombie
      print "Oh really.  Quit looking at me that way.\n\n"

      if subject.z_scale >= 5
        z_result = 'proto_zombie'        
      else subject.z_scale >= 0
        z_result = 'quarantine'        
      end
    end
  
    q4.choice("Can't stop thinking about it.") do |choice|
      ## late stage proto-zombie
      print "You're starting to creep me out.\n\n"
      z_result = 'proto_zombie'
      
    end
  end
  print "**[Debug] End-of-Q4:  Z-scale = #{subject.z_scale}\n" if debug
  
  ## check which state to place subject into
  case z_result
  when 'proto_zombie'
    subject.proto_zombie! unless subject.z_scale >= 9
    
  when 'quarantine'
    subject.quarantine!
    
  when 'let go'
    # do we need to do anything?
    
  end
  sleep 3 unless debug
  
  print "Let's check you're score:  Z-scale = #{subject.z_scale}\n"
  sleep 2 unless debug
  
  if subject.z_scale >= 9
    print "Sorry pal, you're a zombie.\n  [Hey guys, we've got another one!]\n\n"
    
  elsif subject.z_scale == 8
    print "We've got some good news:  Your are not a zombie (yet).  However, you've been infected.  Would you like some tea...?\n\n"
  
  elsif subject.current_state.to_s == "quarantine"
    print "You're test results are in-conclusive, so we'd like to keep you around for a few days for observation.  .\n\n"

  elsif (subject.z_scale == 1) and (z_result == 'let go')
    print "You've had a close call, but are probably OK.\n  Take the test again in another 12-24 hours if you want to be sure.\n\n"
  
  else
    print "Congratulations!  You passed, you are not a zombie.\n  Keep working on your cardio and try real hard to stay that way.\n\n"
  end

  choose do |continue|
    puts "Do you want to take the quiz again?  "
    sleep 1 unless debug

    continue.choice("Yes") do |choice|
      print "OK, good luck.\n\n"
      
    end

    continue.choice("No") do |choice|
      print "Bye.  Stay safe.\n\n"
      done = 'True'
    end
  end
end

exit

