extends Node
class_name Player

var bug_inventory:Array = []  # An array of bug_stats for every individual bug we have in our possession
var bug_counts:Dictionary:    # count by generic BugStats template of bugs currently in our posession
  get:
    var results:Dictionary = {}
    for bug_stats: BugStats in bug_inventory:
      var generic_bug_stat = get_generic_bug_stat(bug_stats.bug_name)
      if results.has(generic_bug_stat):
        results[generic_bug_stat] += 1
      else:
        results[generic_bug_stat] = 1
    return results
  set(v):
    print('WARNING: should we be setting Player.bug_counts directly?')
    bug_counts = v

var currency:float = 0.0    # currency rules everything around the Player

func add_bug(bug_stats: BugStats):
  bug_inventory.append(bug_stats)

func get_generic_bug_stat(bug_name: String) -> BugStats: return BugBuilder.new().BugType[bug_name].call()._bug_stats
