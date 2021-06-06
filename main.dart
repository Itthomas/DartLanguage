import 'dart:io';

void main() {
  print("\x1B[2J\x1B[0;0H");
  var me = createNewPlayer();
  print("\x1B[2J\x1B[0;0H");
  me.showPlayer();
}

String getSkillFromIndex(index) {
  switch(index){
    case 0: {
      return 'intelligence';
    }
    case 1: {
      return 'agility';
    }
    case 2: {
      return 'durability';
    }
    case 3: {
      return 'strength';
    }
    case 4: {
      return 'perception';
    }
    case 5: {
      return 'charisma';
    }
  }
  return 'Unknown';
}

Player createNewPlayer() {
  print('Character Creation:\n');
  stdout.write('What is your new characters name?> ');
  String name = stdin.readLineSync() as String;
  print('\nYou have 40 skill points to divide among the 6 skills:\nIntelligence\nAgility\nDurability\nStrength\nPerception\nCharisma');
  print('Decide how you want to divide these 40 skill points');
  print('among each skill. You may only allocate a maximum of');
  print('10 points per skill, and you must allocate at least 1');
  print('point per skill');

  List skills = [['intelligence', 0], ['agility', 0], ['durability', 0], ['strength', 0], ['perception', 0], ['charisma', 0]];
  bool continueLoop = true;
  int skillIndex = 0;
  num remaining = 40;
  while (continueLoop == true) {
    print('\nyou have ${remaining} points remaining');
    stdout.write('What is ${name}\'s ${skills[skillIndex][0]} level?> ');
    skills[skillIndex][1] = int.parse(stdin.readLineSync() as String);
    if (skills[skillIndex][1] > 10 || skills[skillIndex][1] < 1) {
      print('Remember, for each skill you must allocate at least 1 and no more than 10 skill points. Try again.');
    }
    else if ((remaining - skills[skillIndex][1]) < (5 - skillIndex)) {
      print('you dont have enough skill points left to allocate ${skills[skillIndex][1]} points to ${skills[skillIndex][0]}. Try again');
    }
    else if (skillIndex < 5) {
      remaining -= skills[skillIndex][1];
      skillIndex += 1;
    }
    else if ((remaining - skills[skillIndex][1]) > 0) {
      stdout.write('You still have ${remaining - skills[skillIndex][1]} unused skill points. Would you like to redo skill point allocation? (y/n)?>');
      bool valid = false;
      String option = '';
      while (valid == false) {
        option = stdin.readLineSync() as String;
        if (option.toLowerCase() == 'n' || option.toLowerCase() == 'y') {
          valid = true;
        }
        else {
          print('type \'y\' or \'n\'');
        }
      }
      if (option.toLowerCase() == 'y') {
        skillIndex = 0;
        remaining = 40;
      }
      else {
        continueLoop = false;
      }
    }
    else {
      continueLoop = false;
    }
  }
  Player player = Player(name, skills[0][1], skills[1][1], skills[2][1], skills[3][1], skills[4][1], skills[5][1]);
  return player;
}

class Sentient {
  String name;
  num intelligence;
  num agility;
  num durability;
  num strength;
  num perception;
  num charisma;
  num level;
  num health;

  Sentient({this.name='noName', 
    this.intelligence=0, 
    this.agility=0, 
    this.durability=0, 
    this.strength=0, 
    this.perception=0, 
    this.charisma=0, 
    this.level=1, 
    this.health=0});
}

class Player extends Sentient{
  int experiencePoints = 0;
  int gold = 300;
  var inventory = [Item(itemName: 'Family Heriloom', value: 835, rarity: 'rare', modifiers: [0, 0, 0, 0, 0, 0])];
  Weapon equippedWeapon = Weapon(itemName: 'Fists', modifiers: [0, 1, 0, -2, 0, 0], damageMod: -2, sellable: false);
  Armor equippedArmor = Armor(itemName: 'Beggar Robes', value: 10, modifiers: [0, 0, -2, 0, 0, -2], damageTakeMod: 0);
  Item equippedItem = Item(itemName: 'Brass Ring', rarity: 'common', value: 130, modifiers: [0, 0, 0, 0, 0, 0]);
  Player(String name, num intelligence, num agility, num durability, num strength, num perception, num charisma):
    super(name: name, 
      intelligence: intelligence, 
      agility: agility, 
      durability: durability, 
      strength: strength, 
      perception: perception, 
      charisma: charisma, 
      health: 30);

  void showPlayer() {
    print('${this.name}, level ${this.level} fighter');
    print('\nEquipped Items:');
    print('\tArmor: ${this.equippedArmor.itemName}');
    print('\t\tMerchant Sell Value: ${(this.equippedArmor.value * .6)}');
    print('\t\tRarity: ${this.equippedArmor.rarity}');
    print('\t\tModifiers:');
    print('\t\t\tDamage Reduction: ${this.equippedArmor.damageTakeMod}');
    for (var j=0; j<this.equippedArmor.modifiers.length; j++) {
        if (this.equippedArmor.modifiers[j] > 0){
          print('\t\t\t${getSkillFromIndex(j)} +${this.equippedArmor.modifiers[j]}');
        }
        else if (this.equippedArmor.modifiers[j] < 0){
          print('\t\t\t${getSkillFromIndex(j)} ${this.equippedArmor.modifiers[j]}');
        }
      }
    print('\tWeapon: ${this.equippedWeapon.itemName}');
    print('\t\tMerchant Sell Value: ${(this.equippedWeapon.value * .6)}');
    print('\t\tRarity: ${this.equippedWeapon.rarity}');
    print('\t\tModifiers:');
    print('\t\t\tDamage Modifier: ${this.equippedWeapon.damageMod}');
    for (var j=0; j<this.equippedWeapon.modifiers.length; j++) {
        if (this.equippedWeapon.modifiers[j] > 0){
          print('\t\t\t${getSkillFromIndex(j)} +${this.equippedWeapon.modifiers[j]}');
        }
        else if (this.equippedWeapon.modifiers[j] < 0){
          print('\t\t\t${getSkillFromIndex(j)} ${this.equippedWeapon.modifiers[j]}');
        }
      }
    print('\tItem: ${this.equippedItem.itemName}');
    print('\t\tMerchant Sell Value: ${(this.equippedItem.value * .6)}');
    print('\t\tRarity: ${this.equippedItem.rarity}');
    print('\t\tModifiers:');
    for (var j=0; j<this.equippedItem.modifiers.length; j++) {
        if (this.equippedItem.modifiers[j] > 0){
          print('\t\t\t${getSkillFromIndex(j)} +${this.equippedItem.modifiers[j]}');
        }
        else if (this.equippedItem.modifiers[j] < 0){
          print('\t\t\t${getSkillFromIndex(j)} ${this.equippedItem.modifiers[j]}');
        }
      }
    print('\nInventory:');
    for (var i=0; i<this.inventory.length; i++) {
      print('\t${this.inventory[i].itemName}');
      print('\t\tMerchant Sell Value: ${(this.inventory[i].value * .6)}');
      print('\t\tRarity: ${this.inventory[i].rarity}');
      print('\t\tModifiers:');
      for (var j=0; j<this.inventory[i].modifiers.length; j++) {
        if (this.inventory[i].modifiers[j] > 0){
          print('\t\t\t${getSkillFromIndex(j)} +${this.inventory[i].modifiers[j]}');
        }
        else if (this.inventory[i].modifiers[j] < 0){
          print('\t\t\t${getSkillFromIndex(j)} ${this.inventory[i].modifiers[j]}');
        }
      }
    }
    print('\nSkills:');
    print('\tIntelligence:\t ${this.intelligence}');
    print('\tAgility:\t ${this.agility}');
    print('\tDurability:\t ${this.durability}');
    print('\tStrength:\t ${this.strength}');
    print('\tPerception:\t ${this.perception}');
    print('\tCharisma:\t ${this.charisma}');
  }
}

class Item {
  String itemName;
  int value;
  String rarity;
  bool sellable;
  var modifiers;
  Item({this.itemName='Unknowable Item', this.value=0, this.rarity='common', this.sellable=true, this.modifiers});
}

class Armor extends Item{
  int damageTakeMod;
  Armor({String itemName='Unknowable Item', 
    int value=0, String rarity='common', 
    bool sellable=true, 
    var modifiers, 
    this.damageTakeMod=0}): 
  super(itemName: itemName, 
    rarity: rarity, 
    value: value, 
    sellable: sellable, 
    modifiers: modifiers);
}

class Weapon extends Item{
  int damageMod;
  Weapon({String itemName='Unknowable Item', 
    int value=0, 
    String rarity='common', 
    bool sellable=true, 
    var modifiers, 
    this.damageMod=0}): 
  super(itemName: itemName,
    rarity: rarity, 
    value: value, 
    sellable: sellable, 
    modifiers: modifiers);
}