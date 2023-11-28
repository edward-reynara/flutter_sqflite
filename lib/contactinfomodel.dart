class ContactinfoModel {
    ContactinfoModel({
        this.id,
        this.name,
        this.createdAt,
    });

    int id;
    String name;
    String createdAt;

    factory ContactinfoModel.fromJson(Map<String, dynamic> json) => ContactinfoModel(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt,
    };
}