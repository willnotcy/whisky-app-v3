import 'distillery.dart';

class Whisky {
  Whisky();
  Whisky.full(this.id, this.name, this.distillery_id, this.age, this.notes, this.rating, this.nose, this.taste, this.image_url);

  int id;
  String name;
  int distillery_id;
  Distillery distillery;
  int age;
  String abv;
  String distilled;
  String bottled;
  String volume;
  String bottler;
  String description;
  String notes;
  double rating = 0.0;
  double nose = 0.0;
  double taste = 0.0;
  String image_url = '';

  static final columns = ["id", "name", "distillery_id", "age", "notes", "rating", " nose", "taste", "image_url"];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": name,
      "distillery_id": distillery_id,
      "age": age,
      "notes": notes,
      "rating": rating,
      "nose": nose,
      "taste": taste,
      "image_url": image_url,
    };

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }  

  static fromMap(Map map) {
    Whisky whisky = new Whisky();
    
    whisky.id = map["id"];
    whisky.name = map["name"];
    whisky.distillery_id = map["distillery_id"];
    whisky.age = map["age"];
    whisky.notes = map["notes"];
    whisky.rating = map["rating"];
    whisky.nose = map["nose"];
    whisky.taste = map["taste"];
    whisky.image_url = map["image_url"];

    Distillery distillery = Distillery.full(map["distillery_id"], map["d_name"], map["region"], map["country"], map["d_image_url"]);
    whisky.distillery = distillery;

    return whisky;
  }

  static fromJson(Map json) {
    Whisky whisky = new Whisky();
    whisky.name = json["name"];
    whisky.age = int.tryParse('${json["age"]}'.replaceAll('Y', '')) ?? 0;
    whisky.abv = json["abv"];
    whisky.distilled = json["distilled"];
    whisky.bottled = json["bottled"];
    whisky.volume = json["bottle_volume"];
    whisky.bottler = json["bottler"];
    whisky.description = json["description"];
    whisky.image_url = json["img_url"];

    Distillery distillery = Distillery();
    distillery.name = json["distillery"];
    
    whisky.distillery = distillery;
    return whisky;
  } 
}