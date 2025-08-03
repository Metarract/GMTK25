extends Node
class_name Player

var patchy_has_met := false
var wormfriend_has_met := false
var zebnco_has_met := false

var bug_inventory:Array = []  # An array of bug_stats for every individual bug we have in our possession
var bug_counts:Dictionary:    # count by generic BugStats template of bugs currently in our posession
  get:
    var results:Dictionary = {}
    for bug_stats: BugStats in bug_inventory:
      var bug_name = bug_stats.bug_name
      if results.has(bug_name):
        results[bug_name] += 1
      else:
        results[bug_name] = 1
    return results
  set(v):
    print('WARNING: should we be setting Player.bug_counts directly?')
    bug_counts = v

var currency:int = 0    # currency rules everything around the Player

func add_bug(bug_stats: BugStats):
  bug_inventory.append(bug_stats)
