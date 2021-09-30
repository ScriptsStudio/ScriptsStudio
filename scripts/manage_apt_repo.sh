# Expected to be run with superuser privileges
addrepo() {
  add-apt-repository "$1"
}

delrepo() {
  add-apt-repository --remove "$1"
}
