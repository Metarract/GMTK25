# Git Gud Guide

Basic Git guide that will get you through this workflow easily. All that being said, realistically it is easier to use a
Git client to handle most of these tasks when you're not used to these sorts of things. The workflow will still be the
same, but the client will handle some of the rigmarole surrounding it, like the commands to use etc.

If you're used to using CLI tools, this probably won't be too crazy. Otherwise, no sense in overwhelming yourself for
now.

### What is Git?

Git is a **V**ersion **C**ontrol **S**ystem / tool which allows you to create an efficient history of linked changes to
text files.
Importantly, git is for _text_ files. With effort, it can track binary files, but it's not meant for it. These are
things like images, audio, executables, etc. If you open it up in Notepad, and there's, it's probably a binary file. We
use a file called a `.gitignore` file to designate patterns for files we do NOT want to add to git. Anytime we are
adding things to the repository we should consider whether it is a binary file and whether it should be added to the
`.gitignore` so that we don't accidentally add it to the repo.

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
is far beyond the scope of this document, and it's honestly better not to mess with them anyway).

Git is very smart about how to handle merging these changes, and oftentimes it will just figure things out on its own.
However, sometimes when two separate people's changes have modifications to the same file, you may run into _conflicts_.
In these situations, both changes will be present in the one file, with some special syntax denoting which is incoming (
someone else's changes) and which is outgoing (your changes). You'll have to resolve this change yourself before
continuing. Generally speaking it is better to work in isolated sections in this case - if you've got everything in one
file, you are almost guaranteed to run into conflicts. So we split things out into logically separated sections to help
avoid these sorts of issues. There are other benefits in organizing things this way, but for Git's purposes this is
the most important.

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

As a final note to all of these things, there are exceptions - I won't be going over them, but git is a powerful tool
that can be used in a lot of amazing (but oftentimes stupid) ways. It's best to stick to the basics.

### Commands

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

#### Explanation of Commands

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

## The Meat and Potatoes - A.K.A., the WORKFLOW

Here's the important bits. Should all of that left your eyes rolling towards the back of your head, if nothing
else commit to trying to follow these steps.

After cloning down the repository onto your machine, the basic workflow should be:

1. `git checkout main`
    - switch to the main branch
2. `git pull`
    - `fetch` the latest version of `main` and `merge` it into your local version
3. `git checkout -b <new-branch-name>`
    - create a new `branch` off of your current one, in this case `main`, and then `checkout` that `branch`
4. make some changes for the thing you are doing
5. `git status`
    - check your `status` to see what files you have changed
6. `git add ./folder/` or `git add ./folder/file` or just `git add .`
    - `add` the items you wish to commit to your branch, whether it be everything in a folder, a single file, or every
      change in the current directory
7. `git commit -m "<message here>"`
    - `commit` the items to your branch to save your changes to it, along with a message describing the changes you have
      made
8. GOTO 4 until you feel the thing you are working on is done / ready to be merged into the project
9. if there are changes to the main branch, it may be preferable to bring those changes down locally to make sure
   they are simpatico. Otherwise, this can probably be ignored
    1. `git checkout main` - `git pull` - `git checkout <new-branch-name>`
        - before you push your work up, pull down changes to our `main` branch and merge it into your branch locally
          first to make sure they are
          compatible
        - there are certainly "better" or "different" ways to do this, but let's stick with knowledge that we already
          have
    2. `git merge main`
        - `merge` the `main` branch into your local branch (if there are changes)
        - resolve any conflicts if there are any (if we are not working on the same things, this should not happen)
        - this works because the commit history will be the same whether you merge it now, or merge it later - the
          changes
          are exactly the same
        - so we merge it now, locally, to see if things are broken, and then resolve whatever's broken
        - if there ARE merge conflicts, oftentimes it's better to have a tool to resolve them. VS Code is quite good at
          this, but any Git Client worth it's salt should have something to decide whether to take the _incoming
          change_ (
          whatever was up in the remote) or the _outgoing change_ (your stuff)
        - alternatively, you can examine both changes and make an entirely new change that incorporates both changes
10. `git push origin <new-branch-name>`
    - `push` your branch, with all of its commits, up to the remote repository
11. go to your branch on GitHub and create a pull request (PR) for your branch into the `main` branch
    - there should be a new little section below the `<> Code` button that shows a `Contribute` dropdown, with an option
      to make a Pull Request
    - this just creates a little comparison which shows the sum of all the changes you have made as they apply to master
    - if you merge and resolved locally, there should be no conflicts to worry about here
12. if it all looks good, and you don't think you need someone to double-check it, complete the PR
    - in this situation, just create a Merge Commit as your merging strategy
    - this is the most straightforward method that also preserves all the commits you made
    - alternatively, feel free to ask for a once-over - that's part of what a PR is for, code review
13. GOTO 1 and start again
    - we start from the checkout/pull again because you need to make sure you have the version of `main` that you just
      created, even if you merged it locally earlier—the new merge commit should be pulled down as well so that when you
      create a new branch off of `main` you are starting at the correct spot in the history
