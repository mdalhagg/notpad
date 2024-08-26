class Note {
  String? title;
  String? content;
  int? categoryId;
  bool? isPinned;
  bool? isArchived;
  // cratedAt
  String? createdAt;

  Note(
      {this.title,
      this.content,
      this.categoryId,
      this.isPinned,
      this.isArchived,
      this.createdAt});

  Note.fromJson(Map<dynamic, dynamic> json) {
    title = json['title'];
    content = json['content'];
    categoryId = json['categoryId'];
    isPinned = json['isPinned'];
    isArchived = json['isArchived'];
    createdAt = json['createdAt'];
  }

  toJson() {
    return {
      'title': title,
      'content': content,
      'categoryId': categoryId,
      'isPinned': isPinned,
      'isArchived': isArchived,
      'createdAt': createdAt
    };
  }
}
