
import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'conversation')
class ConversationEntity extends Equatable {

  @PrimaryKey(autoGenerate: true)
  int? conversationId;

  ConversationEntity({this.conversationId});
  /*List<int>? messageList;

  ConversationEntity(this.messageList);*/


  @override
  // TODO: implement props
  List<Object?> get props => [conversationId];

}