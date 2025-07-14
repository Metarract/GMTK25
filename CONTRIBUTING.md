# Contributing

We will not be accepting outside contributions, this is mainly just for the team

## General Workflow

1. check the board `Backlog` to see what needs doing
    - items are in priority order, so you should start at the top of the backlog and make your way down until you can
      find something you can do
    - make sure to let the team know when you're picking something up
2. move the item to `Doing` and put your name on it
3. after finishing, upload / push up your work
   1. if it requires merging, do so
4. inform the team of the changes
5. move your item to `Done`

## Asset Workflow

1. download the latest version of the [assets](https://drive.google.com/drive/folders/1mABOBiUYkEcktTIkc9ELlYjbfZlMKIOX?usp=drive_link) folder in the drive to your local
2. make your updates
3. upload just the files you changed to the drive
   - this way if multiple files are updated you don't overwrite someone else's changes
   - try to keep renames/reorganization to a minimum, so that `.uid` / `.<ext>.import` files remain in the correct spots, as well as referencing the correct files
   - inform the team if renaming/reorganization was necessary

## Coding Workflow

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
    - `push` your branch, with all of its commits, up to the remote repository at `origin`
11. go to your branch on GitHub and create a pull request (PR) for your branch into the `main` branch
    - there should be a new little section below the `<> Code` button that shows a `Contribute` dropdown, with an option
      to make a Pull Request
    - this just creates a little comparison which shows the sum of all the changes you have made as they apply to master
    - if you merge and resolved locally, there should be no conflicts to worry about here
12. if it all looks good, and you don't think you need someone to double-check it, complete the PR
    - alternatively, feel free to ask for a once-over - that's part of what a PR is for, code review
    - don't worry too much about the merge strategy - since this is a short project we will be not be worrying about
      reverting, fixes will be in future pushes. Thus, worrying about who committed what, when, is not important
