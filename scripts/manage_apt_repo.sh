# Expected to be run by user with sudo privileges and source this script from ~/.bashrc
addrepo() {
  sudo add-apt-repository -y "$1"
  sudo apt-get update -y
}

delrepo() {
  sudo add-apt-repository --remove -y "$1"
  sudo apt-get update -y
}
