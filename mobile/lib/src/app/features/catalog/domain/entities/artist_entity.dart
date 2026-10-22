import 'package:equatable/equatable.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/sync_status.dart';

class ArtistEntity extends Equatable {
  final String id;
  final String name;
  final String? thumbnailUrl;
  final SyncStatus syncStatus;
  final DateTime? catalogSyncedAt;

  const ArtistEntity({
    required this.id,
    required this.name,
    this.thumbnailUrl,
    this.syncStatus = SyncStatus.idle,
    this.catalogSyncedAt,
  });

  @override
  String toString() {
    return 'ArtistEntity(id: $id, name: $name, syncStatus: ${syncStatus.value})';
  }

  @override
  List<Object?> get props => [id, name, thumbnailUrl, syncStatus, catalogSyncedAt];
}
