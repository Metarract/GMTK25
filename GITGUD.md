# Git Gud Guide

Basic Git guide that will get you through this workflow (somewhat) easily. All that being said, realistically it is
easier to use a Git client to handle most of these tasks when you're not used to these sorts of things. The workflow
will still be the same, but the client will handle some of the rigmarole surrounding it, like the commands to use etc.

If you're used to using CLI tools, this probably won't be too crazy. Otherwise, no sense in overwhelming yourself for
now. Personally, I prefer using the git CLI directly, but it can be intimidating at first blush.

## What is Git?

Git is a **V**ersion **C**ontrol **S**ystem which allows you to create an efficient history of linked changes to text
files.
Importantly, git is for _text_ files. With effort, it can track binary files, but it's not meant for it. These are
things like images, audio, executables, etc. If you open it up in Notepad, and there's a bunch of crazy characters, it's
probably a binary file. We use a file called a `.gitignore` file to designate patterns for files we do NOT want to add
to git. Anytime we are adding things to the repository we should consider whether it is a binary file and whether it
should be added to the `.gitignore` so that we don't accidentally add it to the repo. We should also include in this
`.gitignore` almost anything that is _generated_ by the engine. `.uid` files for scripts notwithstanding, if the engine
can generate it at build / runtime, it can do it again with little effort, and we shouldn't include it in the
repository. These are usually whole directories that we are excluding in this scenario.

Whole files are not stored in git - only the changes, or the _diffs_ are stored. Each set of changes is stored in a
commit, and each commit links, or _points_ to the previous commit it is based on. What this means is that the _order_ of
the commits is very important - changes are dependent on the state that is resultant of the previous commit's changes.
Out of order commits would mean you could be changing a file before the thing you were changing existed - which is
time-paradox levels of bad. Luckily, the vast majority of the time you shouldn't have to worry about commit history
order at all. Git handles all of it, and only when you're really messing with things can it all go awry.

A git repo is simply a history of commits - a long line of changes stemming from an initial state. You can `branch` off
of that main history, sometimes called the `trunk`, to make changes that deviate from that base commit history. You can
then merge that branching commit history back into the main commit history as long as they can be traced back to a
common parent commit (technically, this isn't true - you can do a lot with git history to do whatever you want. But that
is beyond the scope of this document, and it's honestly better not to mess with them anyway).

Git is very smart about how to handle merging these changes, and oftentimes it will just figure things out on its own.
However, sometimes when two separate people's changes have modifications to the same file, you may run into _conflicts_.
In these situations, both changes will be present in the one file, with some special syntax denoting which is incoming (
someone else's changes) and which is outgoing (your changes). You'll have to resolve this change yourself before
continuing. Generally speaking it is better to work in isolated sections in this case - if you've got everything in one
file, you are almost guaranteed to run into conflicts. So we split things out into logically separated sections to help
avoid these sorts of issues. There are other benefits in organizing things this way, but for Git's purposes this is
the most important. We also try to keep changes to the smallest possible units so that reviewing changes is quick and
easy, and we can easily see the effects of the changes that are being implemented.

There are many methods of collaborating via the aforementioned systems, but for a small project we will be using the
most simple workflow:

- Get the most recent version of the main history line
- Branch off of the main line
- Make changes to said branch
- Merge back into the main line

For a small team of collaborators this allows us to work independently without stepping on each-other's toes very much,
and without overcomplicating things.

We _never_ make changes directly to the `main` branch in this setup - this allows us to always treat it as our "source
of truth", a starting point from which we can simply just get the most recent update to it and start fresh on whatever
new thing we are working on, and know that it's the baseline for what others have as well.

### Important Takeaways

- Git is for text files, not binary files. If a binary file is in the repository, we should add it to the `.gitignore`
- Most generated files should also be ignored. These are usually things generated when compiling / building / running
  the game
    - An exception to this for Godot would be unique identifiers - so-called `.uid` files, and by extension,
      `.<ext>.import` files - as these have a direct correlation between things like say, scripts, and where they are
      pulled into scenes and resources. These must be accurate.
- Git tracks _changes_, not _files_. Each set of changes is a `commit`
- Do not make changes directly to the `main` branch
- When making your changes, first create a new `branch` off of the `main` branch (after ensuring your `main` branch is
  updated)
- _Conflicts_ can occur when multiple people make changes to the same file
- To avoid conflicts, try to work in small, compartmentalized, deliverables
- Do not hesitate to ask for clarification on anything. It is far better to ask than to break, you will not be bothering
  me by doing so
- Stick to the basics for now. There are exceptions to nearly all of these things above, but I won't be explaining them
  here for the sake of time and complexity

## Commands

These are the commands you will probably need to know or be aware of in some way, whether to use directly with the Git
CLI, or with whatever their abstraction is within a Git Client. There are _many_ other commands to git, as well as many
other options and uses to the below commands, but that is beyond the scope of this project.

- `git clone <clone/url>`
- `git checkout <branch-name>`
    - `git checkout -b <branch-name>`
- `git status`
- `git add <./folderpath/>`
    - `git add <./folder/filepath>`
- `git reset <./folderpath/filepath>`
- `git checkout -- <./folderpath/filepath>`
- `git commit -m "<your message here>"`
- `git push <remote-name> <branch-name>`
- `git fetch <remote-name>`
- `git merge <branch-name>`
- `git pull`

### Explanation of Commands

- `git clone <clone/url>`
    - This is your initial command to bring the repository from the `remote`, and put it onto your local machine.
      Generally you'll only ever need to do this once, unless you really screwed something up
    - You can get the clone url from GitHub, there'll be a big green button that says `<> Code` with options for it.
      HTTPS is the most straightforward way, SSH requires some setup. There's instructions in a little info bubble on
      the `<> Code` dropdown
    - We can walk through this one if need be, again it may be easier to just have a client to handle most of this stuff
      if it
      is unfamiliar
- `git checkout <branch-name>`
    - Use this to switch to the branch you specify. For example, if you want to swap to the `main` branch, you would
      write `git checkout main`
    - `-b <branch-name`
        - This one is a bit of a shortcut that makes creating a new branch easier. This will create a new branch of the
          name you specified, and then switch to it
- `git status`
    - This will give you the low-down on all the files you've changed on the branch you on are since the last time you
      committed. It will also make a note of changes you've staged with `add`.
    - IMPORTANT NOTE: You should probably use this _frequently_ to be _certain_ that you are changing what you _think_
      you are changing
- `git add <./folderpath/>` or `<./folder/filepath>`
    - This is used to stage the changes you want to commit to your branch, either everything under a folder path or an
      individual file. Only add the things you want to add. Use `status` frequently to be sure that whatever you added
      didn't have changes you didn't want to commit
- `git reset <./folderpath/filepath>`
    - This is used to unstage changes you have staged with `add` in the case you have made a mistake. This can also be
      used in a more powerful way to mess with your Git history locally, but it's best to just ignore it for now
- `git checkout -- <./folderpath/filepath>`
    - This can be used to reset a changed file to the state it should be according to the current commit. e.g.:
        - You have a file that you have made some changes to since your last commit
        - You have decided that you don't wish to commit these changes, and would rather toss them out entirely, but
          undoing
          those changes back to what it should be might be complicated
        - You can then use `git checkout -- ./folder/file.gd` to `checkout` that file to exactly what it was at the last
          commit
- `git commit -m "<your message here>"`
    - This is used to commit your staged changes from `add` to a single commit on the branch
    - You should put a descriptive message so that anyone looking can at-a-glance understand what your changes were,
      without having to go into the commit itself to try and divine it from the actual changes themselves
- `git push <remote-name> <branch-name>`
    - This is used to push your branch with all of its committed changes to the remote repository (usually `origin`)
    - Do this when you consider your changes to be "complete", and you're ready to merge it back into the `main` branch
      for others to utilize
- `git fetch <remote-name>`
    - Gets the latest changes that are in the remote (again, usually `origin`)
    - This usually includes any new branches, or updates/changes to branches you already have locally
- `git merge <branch-name>`
    - Merge the specified branch into your current branch. The branches should have a common history (it is unlikely
      they won't if you are doing things properly)
    - _May_ generate conflicts if there are changes to the same files
- `git pull`
    - This is a combination of a `fetch` and a `merge`
    - It will fetch down the latest version of the branch you are on, and automatically merge it in
    - Use this when you want to get the most recent update to a certain branch, and you haven't made any local changes
      to it


## Putting it into practice

See [CONTRIBUTING](./CONTRIBUTING.md)
