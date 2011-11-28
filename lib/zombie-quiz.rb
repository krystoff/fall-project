# UWE Ruby Fall 2011 Class
# Fall Project
#   Chris Larson krystoff@uw.edu
#   Andy Litzinger ajlitzin@uw.edu
#   @version 0.2
#
# "Zombie Quiz" runs the self-assessment test
#

require 'optparse'
require 'rubygems'
require 'highline/import'
require File.expand_path(File.dirname(__FILE__) + '/../lib/zombie-state.rb')

options = {}
 
optparse = OptionParser.new do|opts|
  # Define the options, and what they do
  options[:debug] = false
  opts.on( '-d', '--debug', 'Debug output for use during testing' ) do
    options[:debug] = true
  end
end

optparse.parse!

print "\nWelcome to the 'Am I a Zombie' self-assessment test.\n\n"
print "**Help stop the terror from spreading, please answer the following questions honestly.**\n\n"
sleep 3 unless options[:debug]

puts "  First the good news:  if you are reading this and have concerns about whether you are a zombie or not "
puts "(i.e. you are not wholy concerned with an insatiable desire for brains!), then there is still hope.  "
puts "You may not be infected or you may be able to end your life before the infection fully takes hold. :)"
puts

sleep 5 unless options[:debug]

done = nil
until done
  subject = ZombieState.new
  
  ## Question 1
  choose do |q1|
    puts "Have you been in contact with a zombie?  "
    q1.choice(:Yes) do |choice|
      ## risk level-1
      print "Yes?  Well, no surprise, they are taking over, so let's see how much exposure you've had.\n\n"
      subject.exposed!
      sleep 3 unless options[:debug]
      print "**[Debug] End-of-Q1:  Z-scale = #{subject.z_scale}\n" if options[:debug]
      
      ## Question 2
      choose do |q2|
        puts "Were you grabbed, groped, drooled on, or worse?  "
        q2.choice(:Yes) do |choice|
          ## risk level-1-3
          print "Yes again...  Hmmmm, that's worrisome.  Maybe you got off lucky.\n\n"
          sleep 3 unless options[:debug]
  
          ## Question 3
          choose do |q3| 
            puts "Have any of the following happened to you?  "
            q3.choice('Splashed with zombie bodily fluids.') do |choice|
              ## risk level-2
              print "Uggghh.  Stinks doesn't it.  Use lots of bleach and you probably be OK.\n\n"
              subject.exposure_level_2!
              sleep 3 unless options[:debug]
              
            end
            
            q3.choice('Zombie bodily fluids got into my open wounds.') do |choice|
              ## risk level-3
              print "Bad Luck.  You are at risk for being a zombie.  Use lots of bleach and scrub vigorously!\n\n"
              subject.exposure_level_3!
              sleep 3 unless options[:debug]
              
            end
            
            q3.choice('Zombie bodily fluids got into my mouth.') do |choice|
              ## risk level-3
              print "Double Yuck!  That's very gross!  You didn't swallow, did you?!  Gargling with bleach may help if you didn't...\n\n"
              subject.exposure_level_3!
              sleep 3 unless options[:debug]
              
            end
            
            q3.choice("I've been bitten by a zombie.") do |choice|
              ## risk level-4
              print "Very Bad Luck!  Sorry buddy, but you will almost certainly be a zombie.\n\n"
              subject.infected!
              sleep 3 unless options[:debug]
              
            end
            
            q3.choice("None of the above.") do |choice|
              ## stays at risk level-1
              print "Just had a scuffle, but got away?  Good cardio works!\n\n"
              subject.exposure_level_1!
              sleep 3 unless options[:debug]
              
            end            
          end
          print "**[Debug] End-of-Q3:  Z-scale = #{subject.z_scale}\n" if options[:debug]
          
        end
            
        q2.choice(:No) do |choice|
          ## risk level-1
          print "No?  Great!  You're probably fine then.\n\n"
          # no change in subject state
          sleep 3 unless options[:debug]
          
        end
      end
    end
    
    q1.choice(:No) do |choice|
      ## risk level-0
      print "No...  Uhhh, OK.  Are you sure you need to take this test?  Oh, right, you may not remember what happened.\n\n"
      # no change in subject status
      sleep 3 unless options[:debug]
      
    end
  end
    
  print "OK, just one more question.\n\n"
  sleep 3 unless options[:debug]
  
  ## Question 4
  z_result = 'no change'
  choose do |q4|
    ## phenotype test
    puts "How do you feel about eating human brains?  "
    puts "  Please ponder this question carefully and answer as honestly as you can..."
    
    sleep 3 unless options[:debug]
    
    q4.choice("It disgusts me.") do |choice|
      ## possibly infected, but not expressing any signs yet
      print "Good.  That's very good.\n\n"
      
      # no state change if already infected, quarantine if any risk, let go if only exposed
      if subject.z_scale >= 8
        # no change in subject state        
      elsif subject.z_scale >= 3
        z_result = 'quarantine'        
      else
        z_result = 'let go'        
      end
    end
    
    q4.choice("If seasoned properly it might be ok.") do |choice|
      ## could be ok, but best to quarantine to be safe, classify as proto-zombie if high risk
      print "Hmmmm, maybe you just have strange culinary interests.\n\n"
      
      # set proto_z if infected, quarantine if any exposure, let go only if human
      if subject.z_scale == 8
        z_result = 'proto_zombie'        
      elsif subject.z_scale >= 1
        z_result = 'quarantine'        
      else
        z_result = 'let go'        
      end
    end
  
    q4.choice("It is strangely compelling.") do |choice|
      ## proto-zombie response, quarantine if low risk
      print "Oh really.  Quit looking at me that way.\n\n"
      
      # set proto_z for anything above moderate exposure, quarantine otherwise
      if subject.z_scale >= 5
        z_result = 'proto_zombie'        
      else subject.z_scale >= 0
        z_result = 'quarantine'        
      end
    end
  
    q4.choice("Can't stop thinking about it.") do |choice|
      ## definite late stage proto-zombie behavior...
      print "You're starting to creep me out.\n\n"
      z_result = 'proto_zombie'
      
    end
  end
  print "**[Debug] End-of-Q4:  Z-scale = #{subject.z_scale}\n" if options[:debug]
  
  ## check which state to place subject into
  case z_result
  when 'proto_zombie'
    subject.proto_zombie! unless subject.z_scale >= 9
    
  when 'quarantine'
    subject.quarantine!
    
  when 'let go'
    # do we need to do anything?
    
  end
  
  print "Let's check you're score:  Z-scale = #{subject.z_scale}\n"
  sleep 2 unless options[:debug]
  
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
    sleep 1 unless options[:debug]

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

