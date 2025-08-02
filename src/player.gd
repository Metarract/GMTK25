extends Node
class_name Player

var bug_inventory:Array = []  # An array of bug_stats for every individual bug we have in our possession
var bug_counts:Dictionary:    # count by generic BugStats template of bugs currently in our posession  
  get:
    var results:Dictionary = {}
    for bug_stats in bug_inventory:
      if results.has(bug_stats): results[bug_stats] += 1
      else:
        results[bug_stats] = 1       
    return results
  set(v):
    print('WARNING: should we be setting Player.bug_counts directly?')
    bug_counts = v
    
var currency:float = 0.0    # currency rules everything around the Player
