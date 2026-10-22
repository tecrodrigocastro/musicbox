import 'dart:convert';

import 'package:musicbox/src/app/features/auth/data/models/user_model.dart';
import 'package:musicbox/src/app/features/auth/domain/entities/auth_response_entity.dart';

/// Espelha a resposta de `POST /register` e `POST /login`: o usuário vem
/// embrulhado em `data` (convenção do Laravel `JsonResource`) e o token
/// Sanctum (`Authorization: Bearer <token>`) é um campo irmão, fora de `data`.
class AuthResponseModel extends AuthResponseEntity {
  const AuthResponseModel({required super.user, required super.token});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': (user as UserModel).toMap(),
      'token': token,
    };
  }

  factory AuthResponseModel.fromMap(Map<String, dynamic> map) {
    try {
      return AuthResponseModel(
        user: UserModel.fromMap(map['data'] as Map<String, dynamic>),
        token: map['token'] as String,
      );
    } catch (e, s) {
      throw Exception('Error parsing AuthResponseModel: $e \nStack trace: $s');
    }
  }

  String toJson() => json.encode(toMap());

  factory AuthResponseModel.fromJson(String source) => AuthResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
