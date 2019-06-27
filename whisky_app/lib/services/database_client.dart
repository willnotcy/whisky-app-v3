import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whisky_app/models/distillery.dart';
import 'package:whisky_app/models/whisky.dart';

final String tableWhisky = 'whisky';
final String tableDistillery = 'distillery';

class DatabaseClient {
  static final _dbName = 'WhiskyDB.db';
  static final _dbVersion = 1;

  DatabaseClient._privdateConstructor();
  static final DatabaseClient instance = DatabaseClient._privdateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute("""
          CREATE TABLE $tableDistillery (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            region TEXT NOT NULL,
            country TEXT NOT NULL,
            image_url TEXT NOT NULL
          )
    """);

    await db.execute("""
          CREATE TABLE $tableWhisky (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            age INTEGER NOT NULL,
            rating REAL NOT NULL,
            notes TEXT NOT NULL,
            nose REAL NOT NULL,
            taste REAL NOT NULL,
            image_url TEXT NOT NULL,
            distillery_id INTEGER NOT NULL,
            FOREIGN KEY (distillery_id) REFERENCES distillery (id)
              ON DELETE NO ACTION ON UPDATE NO ACTION
          )
          """);

    await seedDB(db);
  }

  Future<int> upsertWhisky(Whisky whisky) async {
    Database db = await database;

    if (whisky.id == null) {
      whisky.id = await db.insert(tableWhisky, whisky.toMap());
    } else {
      await db.update(tableWhisky, whisky.toMap(),
          where: "id = ?", whereArgs: [whisky.id]);
    }

    return whisky.id;
  }

  Future<Whisky> getWhisky(int id) async {
    Database db = await database;

    List<Map> results = await db.query(tableWhisky,
        columns: Whisky.columns, where: "id = ?", whereArgs: [id]);

    Whisky whisky = Whisky.fromMap(results[0]);
    whisky.distillery = await getDistillery(whisky.distillery_id);

    return whisky;
  }

  Future<Distillery> getDistillery(int id) async {
    Database db = await database;

    List<Map> results = await db.query(tableDistillery,
        columns: Distillery.columns, where: "id = ?", whereArgs: [id]);

    Distillery distillery = Distillery.fromMap(results[0]);

    return distillery;
  }

  Future<List<Whisky>> getWhiskies() async {
    Database db = await database;

    //List<Map> results = await db.query(tableWhisky, columns: Whisky.columns);
    List<Map> results = await db.rawQuery("""
        SELECT W.id, W.name, W.distillery_id, W.age, W.notes, W.rating, W.nose, W.taste, W.image_url, D.name as d_name, D.region, D.country, D.image_url as d_image_url FROM
        $tableWhisky W INNER JOIN $tableDistillery D
        on W.distillery_id = D.id
        """);

    List<Whisky> whiskies = new List();
    results.forEach((result) {
      Whisky whisky = Whisky.fromMap(result);
      whiskies.add(whisky);
    });

    return whiskies;
  }

  Future<List<Whisky>> getWhiskiesDescending() async {
    Database db = await database;

    List<Map> results = await db.query(tableWhisky,
        columns: Whisky.columns, orderBy: "id DESC");

    List<Whisky> whiskies = new List();
    results.forEach((result) async {
      Whisky whisky = Whisky.fromMap(result);
      whisky.distillery = await getDistillery(whisky.distillery_id);
      whiskies.add(whisky);
    });

    return whiskies;
  }

  seedDB(Database db) async {
    List<Distillery> distilleries = [
      Distillery.full(
          1, 'Aberargie', 'Lowland', 'Scotland', 'assets/lowlands.png'),
      Distillery.full(
          2, 'Aberfeldy', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          3, 'Aberlour', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(4, 'Abhainn Dearg', ' Isle of Lewis"', 'Scotland',
          'assets/islands.png'),
      Distillery.full(
          5, 'Ailsa Bay', 'Lowland', 'Scotland', 'assets/lowlands.png'),
      Distillery.full(
          6, 'Allt-A-Bhainne', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          7, 'Annandale', 'Lowland', 'Scotland', 'assets/lowlands.png'),
      Distillery.full(
          8, 'Arbikie', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(9, 'Ardbeg', 'Islay', 'Scotland', 'assets/islay.png'),
      Distillery.full(
          10, 'Ardmore', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(11, 'Ardnahoe', 'Islay', 'Scotland', 'assets/islay.png'),
      Distillery.full(
          12, 'Ardnamurchan', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(13, 'Arran', 'Island', 'Scotland', 'assets/islands.png'),
      Distillery.full(
          14, 'Auchentoshan', 'Lowland', 'Scotland', 'assets/lowlands.png'),
      Distillery.full(
          15, 'Auchroisk', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          16, 'Aultmore', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          17, 'Balblair', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          18, 'Ballindalloch', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          19, 'Balmenach', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          20, 'Balvenie', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(21, 'Barra', 'Island', 'Scotland', 'assets/islands.png'),
      Distillery.full(
          22, 'Ben Nevis', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          23, 'BenRiach', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          24, 'Benrinnes', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          25, 'Benromach', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          26, 'Bladnoch', 'Lowland', 'Scotland', 'assets/lowlands.png'),
      Distillery.full(
          27, 'Blair Athol', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          28, 'Borders', 'Lowland', 'Scotland', 'assets/lowlands.png'),
      Distillery.full(29, 'Bowmore', 'Islay', 'Scotland', 'assets/islay.png'),
      Distillery.full(
          30, 'Royal Brackla', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          31, 'Braeval', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          32, 'Bruichladdich', 'Islay', 'Scotland', 'assets/islay.png'),
      Distillery.full(
          33, 'Bunnahabhain', 'Islay', 'Scotland', 'assets/islay.png'),
      Distillery.full(34, 'Caol Ila', 'Islay', 'Scotland', 'assets/islay.png'),
      Distillery.full(
          35, 'Cardhu', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          36, 'Clydeside', 'Lowland', 'Scotland', 'assets/lowlands.png'),
      Distillery.full(
          37, 'Clynelish', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          38, 'Cragganmore', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          39, 'Craigellachie', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          40, 'Daftmill', 'Lowland', 'Scotland', 'assets/lowlands.png'),
      Distillery.full(
          41, 'Dailuaine', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          42, 'Dalmore', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          43, 'Dalmunach', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          44, 'Dalwhinnie', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          45, 'Deanston', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          46, 'Dornoch', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          47, 'Dufftown', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          48, 'Eden Mill', 'Lowland', 'Scotland', 'assets/lowlands.png'),
      Distillery.full(
          49, 'Edradour', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          50, 'Fettercairn', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          51, 'Glenallachie', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          52, 'Glenburgie', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          53, 'Glencadam', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          54, 'Glendronach', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          55, 'Glendullan', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          56, 'Glen Elgin', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          57, 'Glenfarclas', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          58, 'Glenfiddich', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          59, 'Glen Garioch', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          60, 'Glenglassaugh', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          61, 'Glengoyne', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          62, 'Glen Grant', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          63, 'Glengyle', 'Campbeltown', 'Scotland', 'assets/campbeltown.png'),
      Distillery.full(
          64, 'Glen Keith', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          65, 'Glenkinchie', 'Lowland', 'Scotland', 'assets/lowlands.png'),
      Distillery.full(
          66, 'Glenlivet', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          67, 'Glenlossie', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          68, 'Glenmorangie', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          69, 'Glen Moray', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          70, 'Glen Ord', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          71, 'Glenrothes', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(72, 'Glen Scotia', 'Campbeltown', 'Scotland',
          'assets/campbeltown.png'),
      Distillery.full(
          73, 'Glen Spey', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          74, 'Glentauchers', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          75, 'Glenturret', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          76, 'GlenWyvis', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(77, 'Harris', 'Island', 'Scotland', 'assets/islands.png'),
      Distillery.full(
          78, 'Highland Park', 'Island', 'Scotland', 'assets/islands.png'),
      Distillery.full(
          79, 'Inchdairnie', 'Lowland', 'Scotland', 'assets/lowlands.png'),
      Distillery.full(
          80, 'Inchgower', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          81, 'Jura', ' Isle of Jura"', 'Scotland', 'assets/islands.png'),
      Distillery.full(82, 'Kilchoman', 'Islay', 'Scotland', 'assets/islay.png'),
      Distillery.full(
          83, 'Kingsbarns', 'Lowland', 'Scotland', 'assets/lowlands.png'),
      Distillery.full(
          84, 'Kininvie', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          85, 'Knockando', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          86, 'Knockdhu', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(87, 'Lagavulin', 'Islay', 'Scotland', 'assets/islay.png'),
      Distillery.full(88, 'Laphroaig', 'Islay', 'Scotland', 'assets/islay.png'),
      Distillery.full(
          89, 'Leven', 'Lowland', 'Scotland', 'assets/lowlands.png'),
      Distillery.full(
          90, 'Lindores Abbey', 'Lowland', 'Scotland', 'assets/lowlands.png'),
      Distillery.full(
          91, 'Linkwood', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          92, 'Loch Lomond', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(93, 'Royal Lochnagar', 'Highland', 'Scotland',
          'assets/highlands.png'),
      Distillery.full(
          94, 'LoneWolf', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          95, 'Longmorn', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          96, 'Macallan', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          97, 'Macduff', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          98, 'Mannochmore', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          99, 'Miltonduff', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          100, 'Mortlach', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          101, 'Ncn\'ean', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          102, 'Oban', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          103, 'Pulteney', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          104, 'Raasay', 'Island', 'Scotland', 'assets/islands.png'),
      Distillery.full(
          105, 'Roseisle', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(106, 'Scapa', 'Island', 'Scotland', 'assets/islands.png'),
      Distillery.full(
          107, 'Speyburn', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          108, 'Speyside', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(109, 'Springbank', 'Campbeltown', 'Scotland',
          'assets/campbeltown.png'),
      Distillery.full(
          110, 'Strathearn', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          111, 'Strathisla', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          112, 'Strathmill', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          113, 'Talisker', ' Isle of Skye"', 'Scotland', 'assets/islands.png'),
      Distillery.full(
          114, 'Tamdhu', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          115, 'Tamnavulin', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          116, 'Teaninich', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          117, 'Tobermory', ' Isle of Mull"', 'Scotland', 'assets/islands.png'),
      Distillery.full(
          118, 'Tomatin', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          119, 'Tomintoul', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          120, 'Torabhaig', ' Isle of Skye"', 'Scotland', 'assets/islands.png'),
      Distillery.full(
          121, 'Tormore', 'Speyside', 'Scotland', 'assets/speyside.png'),
      Distillery.full(
          122, 'Tullibardine', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          123, 'Twin River', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          124, 'Wolfburn', 'Highland', 'Scotland', 'assets/highlands.png'),
      Distillery.full(
          125, 'Rosebank', 'Lowland', 'Scotland', 'assets/lowlands.png'),
      Distillery.full(
          126, 'Scotch Blend', '', 'Scotland', 'assets/scotland.png'),
      Distillery.full(
          127, 'Strathclyde', 'Lowland', 'Scotland', 'assets/lowlands.png'),

      // Canadian
      Distillery.full(128, 'Canadian Blend', '', 'Canada', 'assets/canada.png'),

      // Irish
      Distillery.full(
          129, 'Irish Distillers', '', 'Ireland', 'assets/ireland.png'),
      Distillery.full(130, 'Bushmills', '', 'Ireland', 'assets/ireland.png'),
      Distillery.full(131, 'Cooley', '', 'Ireland', 'assets/ireland.png'),
      Distillery.full(132, 'New Midleton', '', 'Ireland', 'assets/ireland.png'),

      // American
      Distillery.full(133, 'Bulleit Distilling Company', 'Kentucky', 'USA',
          'assets/kentucky.png'),
      Distillery.full(
          134, 'Beam Suntory', 'Kentucky', 'USA', 'assets/kentucky.png'),
      Distillery.full(
          135, 'Heaven Hill', 'Kentucky', 'USA', 'assets/kentucky.png'),
      Distillery.full(136, 'Sazerac', 'Kentucky', 'USA', 'assets/kentucky.png'),
      Distillery.full(
          137, 'Buffalo Trace', 'Kentucky', 'USA', 'assets/kentucky.png'),
      Distillery.full(
          138, 'Jim Beam', 'Kentucky', 'USA', 'assets/kentucky.png'),
      Distillery.full(139, 'Willet', 'Kentucky', 'USA', 'assets/kentucky.png'),
      Distillery.full(
          140, 'Jack Daniel\'s', 'Tennessee', 'USA', 'assets/tennessee.png'),
      Distillery.full(
          141, 'Barton 1792', 'Kentucky', 'USA', 'assets/kentucky.png'),
      Distillery.full(
          142, 'Wild Turkey', 'Kentucky', 'USA', 'assets/kentucky.png'),

      // Spanish
      Distillery.full(143, 'Molino del Arco', '', 'Spain', 'assets/spain.png'),

      // Australian
      Distillery.full(
          144, 'Hellyers Road', 'Tasmania', 'Australia', 'assets/tasmania.png'),

      // Danish
      Distillery.full(145, 'Braunstein', '', 'Denmark', 'assets/denmark.png'),
      Distillery.full(146, 'Stauning', '', 'Denmark', 'assets/denmark.png'),
    ];

    distilleries.forEach((distillery) {
      db.insert(tableDistillery, distillery.toMap());
    });

    List<Whisky> whiskies = [
      Whisky.full(1, 'Glenfiddich 18', 58, 18, '', 4.0, 0.0, 4.0,
          'https://static.whiskybase.com/storage/whiskies/3/9/587/77204-big.jpg'),
      Whisky.full(2, 'Glenfiddich 12', 58, 12, '', 3.0, 0.0, 3.0,
          'https://static.whiskybase.com/storage/whiskies/4/0/015/77404-big.jpg'),
      Whisky.full(3, 'Glenfiddich 14 Rich Oak', 58, 14, '', 2.0, 0.0, 2.0,
          'https://static.whiskybase.com/storage/whiskies/1/0/9147/216617-big.jpg'),
      Whisky.full(4, 'Glenfiddich 15 Solera', 58, 15, '', 3.0, 0.0, 3.0,
          'https://static.whiskybase.com/storage/whiskies/5/9/469/93075-big.jpg'),
      Whisky.full(5, 'Springbank 12', 109, 12, '', 6.0, 0.0, 6.0,
          'https://cdn2.masterofmalt.com/whiskies/p-2813/springbank/springbank-12-year-oldcask-strength-56-2-whisky.jpg?ss=2.0'),
      Whisky.full(6, 'Port Charlotte', 32, 0, '', 0.0, 0.0, 0.0, ''),
    ];

    whiskies.forEach((whisky) {
      db.insert(tableWhisky, whisky.toMap());
    });
  }
}
