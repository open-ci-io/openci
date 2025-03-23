import 'package:freezed_annotation/freezed_annotation.dart';

part 'repository.freezed.dart';
part 'repository.g.dart';

@freezed
class OpenCIGitHubRepository with _$OpenCIGitHubRepository {
  const factory OpenCIGitHubRepository({
    @JsonKey(name: 'full_name') required String fullName,
    required int id,
    required String name,
    @JsonKey(name: 'node_id') required String nodeId,
    required bool private,
  }) = _OpenCIGitHubRepository;

  factory OpenCIGitHubRepository.fromJson(Map<String, Object?> json) =>
      _$OpenCIGitHubRepositoryFromJson(json);
}
