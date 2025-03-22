// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openci_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OpenCIUserImpl _$$OpenCIUserImplFromJson(Map<String, dynamic> json) =>
    _$OpenCIUserImpl(
      userId: json['userId'] as String,
      createdAt: (json['createdAt'] as num).toInt(),
      github: json['github'] == null
          ? null
          : OpenCIUserGitHub.fromJson(json['github'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OpenCIUserImplToJson(_$OpenCIUserImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'createdAt': instance.createdAt,
      'github': instance.github?.toJson(),
    };
