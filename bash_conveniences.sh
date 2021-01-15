# These are aliases and setups you can add to bashrc 
# to make things "easy".

# Use rsync to list files different in a remote and local dir
## $> whatisdiff  <remote-dir>  <local-dir>
alias whatisdiff="rsync -zrvnci"

# A quieter SSH (ignores key-checking) .. dangerous!
# Useful if you have local Odroids/RPis with similar addresses
alias qssh="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
alias qscp="scp -o UserKnownHostsFile=/dev/null"

# Always pick the best editor there is:
export EDITOR=nano
