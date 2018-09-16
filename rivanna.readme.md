# Rivanna Howto

Rivanna is UVA's high power computing cluster. It has something stupid like over 1000 collective CPU cores, and several terabytes of collective RAM. It goes really fast.

## How do I access it?

1. login with `ssh -Y <computing ID>@rivanna.hpc.virginia.edu`. For example, I would type `ssh -Y dtc9bb@rivanna.hpc.virginia.edu`.
  - This must be done in a terminal with SSH support. Your options are `Git Bash`, which is probably already installed, `Cygwin` if you want a standalone solution, or `WSL` if you're like me and you like Linux but need to use Windows.
  - Alternatively you can use an SSH client like [MobaXTerm](https://mobaxterm.mobatek.net/) or [PuTTy](https://www.putty.org/) if you're some kind of monster that wants to use a GUI... _For accessing a remote **command-line terminal**_. That being said, the former will let you use graphical programs like Matlab via remote X connection. I have not tried this; if you want to, enjoy.
  - Your password is your EServices password. I.E. the one you use to log into SIS.
  - Note: If you are off campus, you have to use the [UVA Anywhere VPN](http://its.virginia.edu/vpn/) for security reasons.
2. Now you're in your home directory. You get 50gb of storage and you can put whatever you want in it. Before we go over what to do next, let's go over what **not** to do:
  - **Do not run jobs for more than a few minutes directly from the terminal.** Why not? Because everyone who is logged into Rivanna uses the same frontend node. So if you run long, CPU-intensive jobs directly from the terminal, you will cause everyone else's terminal to lag. You will occasionally notice your terminal freezing - this isn't because your connection is bad. It's because some asshole undergrad is running their jobs on the frontend node.
  - You can run your favorite text editor or any UNIX utilities from the command line. Just, generally, if it runs longer than a few minutes and it'll be chugging hard, don't run it, or kill it after a few minutes.
  - If you violate this rule, your connection will be terminated without warning. If you do it repeatedly, both you and Kozminski will get formal emails asking you to stop. If you keep doing it, you'll be banned from the cluster.
  - Aside from that, don't be stupid. All of your interactions with the server are logged, so don't do anything on the cluster that isn't related to our research.
  
## How do I get work done?

1. `git clone` any relevant repositories. For modeling, this would be `git clone https://github.com/Virginia-iGEM/2018-modeling`.
2. `module load matlab`. You have to rerun this any time you logout and log back in.
3. `cd` into your repo and run whatever function you want with `matlab -nojvm -nodisplay -nosplash -singleCompThread -r "RunFunction(inputs);exit"`. Note the exit at the end of the input; this is needed to make Matlab exit properly.
4. This is good for testing, but if your job's gonna last more than one minute, as mentioned above, you should probably kill it before it runs too long. You can test to see if things are working by running a really short job.
5. Alright, now to run real boy jobs. As you might guess, you can run jobs for longer than a minute; to do this you need to make a batch. I've set up an example batch file named `run.sh` in the modeling folder. Please open it with your favorite text editor (`nano` is foolproof, `vim` or `emacs` if you're feeling ballsy).

## Running jobs

``` bash
#!/bin/bash
#SBATCH -N 1                 # Number of nodes
#SBATCH --ntasks-per-node=1  # Number of cores
#SBATCH -t 00:05:00          # Runtime - job will be killed after this
#SBATCH -A virginia_igem     # Our allocation - don't change this
#SBATCH -p standard          # Node type - you shouldn't have a reason to change
#SBATCH --output=output.txt  # stdout is piped to this file

# Run program
module load matlab
cd $SLURM_SUBMIT_DIR
matlab -nojvm -nodisplay -nosplash -singleCompThread -r  "RunFunction(inputs);exit"
```

The first lines are just configuration necessary to tell Rivanna's job manager, SLURM, how to run our job. The only one you should ever need to change is:

`#SBATCH -t 00:05:00`

This is how long your job will run; HH:MM:SS. Regardless of how long your program runs - it will be killed the moment this timer runs out. If you don't know how long your program's gonna take to run, first try with a really generous time (if you think your job's gonna take half an hour, give it an hour). Once your program completes, check `output.txt` for runtime. But... Don't be too generous... Giving a program that'll take an hour to run a day of clocktime is unreasonable. We have a limited number of core hours and we are charged core hours for the amount of time we schedule, _not_ the amount of time or program takes to run.

I've realized that we don't print runtime to stdout - we probably should.

All the lines after `# Run program` are the meat of our script.

`module load matlab` puts matlab on our path.
`cd $SLURM_SUBMIT_DIR` changes dir to the directory your batch script is submitted from.
`matlab -nojvm -nodisplay -nosplash -singleCompThread -r  "RunFunction(inputs);exit"` runs a Matlab function from a file in the current directory with the given inputs. Then it exits.

The only lines you should need to modify are the `matlab` invocation (replace `RunFunction(inputs)` with your function with inputs) and the `#SBATCH -t` line with an appropriate time for your job.

Note that you can overwrite this file, or save it as a new file (keep track of the name of the new file if you save it as such).

Once you've saved, `sbatch <filename>`. For example, if you're using the `run.sh` file, you'd enter `sbatch run.sh`.

## Controlling jobs

You've now submitted a job. Take note of the job ID, as you can use this to view and manipulate your job.

Let's go over some important commands; substitute your computing ID any time you see `<computing id>`; for example I'd type `dtc9bb`.
- To see what jobs you have running: `squeue -u <computing id>`
- To see a specific job: `sstat <jobid>`
- To cancel all of your jobs: `scancel -u <computing id>`
- To cancel a specific job: `scancel <jobid>`

For more complicated job manipulation, such as submitting arbitrary numbers of parallel jobs with different parameters, running interactive jobs, or having jobs dependent on one another, see [Rivanna's article on Slurm](https://arcs.virginia.edu/slurm).

## Resources

Rivanna has written a lot of fantastic articles on using their cluster. See the following:
- [Getting started guide](https://arcs.virginia.edu/user-guide)
- [General user guide](https://arcs.virginia.edu/user-guide)
