# pi-bootstrap

## what
this is a thing i use when i first fire up a raspberry pi 4 to get the environment into a state that i like. 

- it modifies the apt repositories to use `bookworm` and performs a hands-free full-upgrade.
- it adds some applications i typically use in my environment, like tmux, go, git..
- it adds configs for nano to enable line numbers and syntax highlighting, and enables mouse in tmux
- it does some basic logging for the install progress


## next
future goals:

- fetch a few of my own utility repos that i typically use, like [appserve](https://github.com/donuts-are-good/appserve)
- performance profile selector
- custom gpu ram settings for headless operation

## license
mit license, @donuts-are-good 2023
