enum ChatModel {
  GPT_4_TURBO_PREVIEW(name: "gpt-4-turbo-preview"),
  GPT_3_5_TURBO(name: "gpt-3.5-turbo"),
  GPT_4(name: "gpt-4"),
  GPT_3_5_TURBO_0301(name: "gpt-3.5-turbo-0301");

  final String name;

  const ChatModel({required this.name});
}
