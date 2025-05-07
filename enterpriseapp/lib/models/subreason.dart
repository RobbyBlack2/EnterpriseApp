class SubReason {
  final int index;
  final String title;

  SubReason({required this.index, required this.title});

  factory SubReason.fromJson(Map<String, dynamic> json) {
    return SubReason(
      index: json['index'] as int,
      title: json['title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'index': index, 'title': title};
  }
}
