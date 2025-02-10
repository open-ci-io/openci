String cloneCommand(String repoUrl, String branch, String token) {
  return 'git clone -b $branch https://x-access-token:$token@${repoUrl.replaceFirst("https://", "")}';
}
