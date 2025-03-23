// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openci_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OpenCIUser _$OpenCIUserFromJson(Map<String, dynamic> json) => _OpenCIUser(
      userId: json['userId'] as String,
      createdAt: (json['createdAt'] as num).toInt(),
      github: json['github'] == null
          ? null
          : OpenCIUserGitHub.fromJson(json['github'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OpenCIUserToJson(_OpenCIUser instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'createdAt': instance.createdAt,
      'github': instance.github?.toJson(),
    };
