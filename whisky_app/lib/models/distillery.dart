class Distillery {
  Distillery();
  Distillery.full(this.id,this.name,this.region,this.country,this.image_url);

  int id;
  String name;
  String region;
  String country;
  String image_url;

  static final columns = ["id", "name", "region", "country", "image_url"];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": name,
      "region": region,
      "country": country,
      "image_url": image_url,
    };

    if (id != null){
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map) {
    Distillery distillery = new Distillery();
    distillery.id = map["id"];
    distillery.name = map["name"];
    distillery.region = map["region"];
    distillery.country = map["country"];
    distillery.image_url = map["image_url"];

    return distillery;
  }
}