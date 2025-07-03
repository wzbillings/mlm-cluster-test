
# mlm-cluster-test

<!-- badges: start -->
<!-- badges: end -->

In this project I'm doing a simple test of some bayesian models on the cluster.

To run a project on the cluster:
1. You need a terminal where you can use `ssh`, you need the UGA VPN if you aren't on campus, and you should register for Globus and install Globus personal connect.
2. You need to have a registered account on the sapelo2 cluster, which means you have to finish some GACRC trainings.
3. First transfer your R project to the cluster, Globus connect is the fastest way (if you do it on campus it will be really fast) but you can also use `scp`. The GACRC wiki has more information on this including steps to set up Globus.
4. Remember you need to move any directory where you are actually running code to `/scratch/$USER` on the cluster, not `/home/$USER`. The `home` directory is for permanent storage, the `scratch` directory is for temporary storage while you run code. You will slow down the login node and GACRC will terminate your job if you run code in `/home/$USER`. (Note that `$USER` is a bash variable that will get replaced by your myID.)
5. `cd` into your R project IN THE `/scratch/$USER` DIRECTORY. Use the command `interact` to start an interactive job. Then run `module load R/version` in the terminal to get access to R. You can use `module spider R` to see the available R versions, note that `module load R` will autocomplete to the newest version of R if you don't type anything else. (In a job submission script you should ALWAYS type `R/4.4.2` or whatever version you want, it will autocomplete the rest of the name. If there are two different modules for the R version you want to use, you should always write out the entire thing.)
6. Now that you have R loaded, run the command `R` in the console to open an R prompt. Now you need to install any packages and system dependencies that you need. If you do `renv::restore()` in an up-to-date `renv` project it will probably work fine, if you get any errors try specifically installing those packages with compilation from source. Note that the package `qs2` seems to be broken on the cluster right now so don't use it. ZB had to force compile any packages that referenced system dependencies like BLAS.
7. Type `q()` to close the R session. If you need to do anything else interactive to set up your project, do it now.
8. Type `exit` to close the interactive session and go back to the login/submission node.
9. Now you run your job submission script, see ZB's example in this repo or in the billings-comp-agdist-project or billings-breadth-quantification-project repos titled `job.sh`. Amanda Skarlupka wrote an example of using another more complicated type of parallel processing in the archive of the breadth quantification project, but ZB doesn't understand how it works. Run the script by typing `sbatch job.sh` or whatever your `.sh` file is named.
10. You can monitor the status of your jobs with `sq --me` or if you use targets (or probably other frameworks) you can set it up to print the logs for you.

Once your job is done you can use globus connect to transfer the files back to your computer. ZB was able to get ~100 MBPS transferring to a computer on campus but only ~4 MPBS transferring to home computer, so it was literally faster to transfer to the office machine (which has to be powered on and awake), drive to campus, and copy to a removable drive for big transfers.

See also: [targets template for sapelo2](https://github.com/wzbillings/targets-uga-gacrc) although I don't remember if I actually finished editing this or not. But it has some important changes from the template I copied.
