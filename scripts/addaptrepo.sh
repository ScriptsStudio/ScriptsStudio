addrepo() {
  echo "deb $1 $(lsb_release -cs) main" | sudo tee -a /etc/apt/sources.list

}

delrepo() {
  

}
