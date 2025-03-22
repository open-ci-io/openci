String cloneCommand(String repoFullName, String branch, String token) {
  return 'git clone -b $branch https://x-access-token:$token@github.com/$repoFullName';
}
