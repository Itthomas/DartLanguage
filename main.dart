import 'dart:io'; // input/output dart library
void main() { // Main function. every dart program starts here.
  print("\x1B[2J\x1B[0;0H"); //clear terminal
  var player = createNewPlayer(); //call a function to create a player object
  print("\x1B[2J\x1B[0;0H");
  player.showPlayer(); //call a method of the player object to display the player's inventory & stats
}

String getSkillFromIndex(index) { //convert an index to its respective skill
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

Player createNewPlayer() { //get user input for customizeable character attributes, and use those values to initialize and return a player object
  print('Character Creation:\n');
  stdout.write('What is your new characters name?> ');
  String name = stdin.readLineSync() as String; //get character name from user
  print('\nYou have 40 skill points to divide among the 6 skills:\nIntelligence\nAgility\nDurability\nStrength\nPerception\nCharisma');
  print('Decide how you want to divide these 40 skill points');
  print('among each skill. You may only allocate a maximum of');
  print('10 points per skill, and you must allocate at least 1');
  print('point per skill');

  List skills = [['intelligence', 0], ['agility', 0], ['durability', 0], ['strength', 0], ['perception', 0], ['charisma', 0]];
  bool continueLoop = true;
  int skillIndex = 0;
  num remaining = 40;
  while (continueLoop == true) { //loop through each skill/attribute and assign user imput values
    print('\nyou have ${remaining} points remaining');
    stdout.write('What is ${name}\'s ${skills[skillIndex][0]} level?> ');
    skills[skillIndex][1] = int.parse(stdin.readLineSync() as String); // get the input
    if (skills[skillIndex][1] > 10 || skills[skillIndex][1] < 1) { // if the user entered a value > 10 or < 1, make them try again
      print('Remember, for each skill you must allocate at least 1 and no more than 10 skill points. Try again.');
    }
    else if ((remaining - skills[skillIndex][1]) < (5 - skillIndex)) { //if there wont be enough skill points for the remaining skills to have at least 1 point each make the user re-try
      print('you dont have enough skill points left to allocate ${skills[skillIndex][1]} points to ${skills[skillIndex][0]}. Try again');
    }
    else if (skillIndex < 5) { //continue to the next skill
      remaining -= skills[skillIndex][1];
      skillIndex += 1;
    }
    else if ((remaining - skills[skillIndex][1]) > 0) { // if the player still has unallocated skill points ask if they want to redo on not
      stdout.write('You still have ${remaining - skills[skillIndex][1]} unused skill points. Would you like to redo skill point allocation? (y/n)?>');
      bool valid = false;
      String option = '';
      while (valid == false) { // input validation
        option = stdin.readLineSync() as String; // get input from user
        if (option.toLowerCase() == 'n' || option.toLowerCase() == 'y') { //input is valid
          valid = true;
        }
        else { // input is invalid, try again
          print('type \'y\' or \'n\'');
        }
      }
      if (option.toLowerCase() == 'y') { // reset to allow user to reallocate skill points from the beginning
        skillIndex = 0;
        remaining = 40;
      }
      else { // user is cool with unallocated skill points, continue
        continueLoop = false;
      }
    }
    else { // break the loop and continue
      continueLoop = false;
    }
  }
  Player player = Player(name, skills[0][1], skills[1][1], skills[2][1], skills[3][1], skills[4][1], skills[5][1]); // create an instance of the player
  return player;
}

class Sentient { // any living being with skills, a level, and health
  String name;
  num intelligence;
  num agility;
  num durability;
  num strength;
  num perception;
  num charisma;
  num level;
  num health;

  Sentient({this.name='noName', // initialize and assign parameter values
    this.intelligence=0, 
    this.agility=0, 
    this.durability=0, 
    this.strength=0, 
    this.perception=0, 
    this.charisma=0, 
    this.level=1, 
    this.health=0});
}

class Player extends Sentient{ // main player character. Inherits from Sentient
  int experiencePoints = 0;
  int gold = 300;
  // create items to initially fill the players inventory and equip some
  var inventory = [Item(itemName: 'Family Heriloom', value: 835, rarity: 'rare', modifiers: [0, 0, 0, 0, 0, 0])];
  Weapon equippedWeapon = Weapon(itemName: 'Fists', modifiers: [0, 1, 0, -2, 0, 0], damageMod: -2, sellable: false);
  Armor equippedArmor = Armor(itemName: 'Beggar Robes', value: 10, modifiers: [0, 0, -2, 0, 0, -2], damageTakeMod: 0);
  Item equippedItem = Item(itemName: 'Brass Ring', rarity: 'common', value: 130, modifiers: [0, 0, 0, 0, 0, 0]);

  Player(String name, num intelligence, num agility, num durability, num strength, num perception, num charisma): // initialize
    super(name: name, // assign parameter values to the superclass
      intelligence: intelligence, 
      agility: agility, 
      durability: durability, 
      strength: strength, 
      perception: perception, 
      charisma: charisma, 
      health: 30);

  void showPlayer() { // Display the players inventory and attributes
    print('${this.name}, level ${this.level} fighter');
    print('\tExperience: ${this.experiencePoints}')
    print('\tMax Health: ${this.health}')
    print('\tGold: ${this.gold}')
    print('\nEquipped Items:');
    print('\tArmor: ${this.equippedArmor.itemName}');
    print('\t\tMerchant Sell Value: ${(this.equippedArmor.value * .6)}');
    print('\t\tRarity: ${this.equippedArmor.rarity}');
    print('\t\tModifiers:');
    print('\t\t\tDamage Reduction: ${this.equippedArmor.damageTakeMod}');
    for (var j=0; j<this.equippedArmor.modifiers.length; j++) { //iterate through each modifier and print only the non-zero ones
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
    for (var j=0; j<this.equippedWeapon.modifiers.length; j++) { //iterate through each modifier and print only the non-zero ones
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
    for (var j=0; j<this.equippedItem.modifiers.length; j++) { //iterate through each modifier and print only the non-zero ones
        if (this.equippedItem.modifiers[j] > 0){
          print('\t\t\t${getSkillFromIndex(j)} +${this.equippedItem.modifiers[j]}');
        }
        else if (this.equippedItem.modifiers[j] < 0){
          print('\t\t\t${getSkillFromIndex(j)} ${this.equippedItem.modifiers[j]}');
        }
      }
    print('\nInventory:');
    for (var i=0; i<this.inventory.length; i++) { // iterate through each inventory item
      print('\t${this.inventory[i].itemName}');
      print('\t\tMerchant Sell Value: ${(this.inventory[i].value * .6)}');
      print('\t\tRarity: ${this.inventory[i].rarity}');
      print('\t\tModifiers:');
      for (var j=0; j<this.inventory[i].modifiers.length; j++) { //iterate through each modifier and print only the non-zero ones
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

class Item { // an item that the player can hold in their inventory
  String itemName;
  int value;
  String rarity;
  bool sellable;
  var modifiers;
  Item({this.itemName='Unknowable Item', this.value=0, this.rarity='common', this.sellable=true, this.modifiers});
}

class Armor extends Item{ // a piece of armor that the player can equip in their armor slot, protects the player
  int damageTakeMod;
  Armor({String itemName='Unknowable Item', 
    int value=0, String rarity='common', 
    bool sellable=true, 
    var modifiers, 
    this.damageTakeMod=0}): 
  super(itemName: itemName, // inherits from Item
    rarity: rarity, 
    value: value, 
    sellable: sellable, 
    modifiers: modifiers);
}

class Weapon extends Item{ //a weapon that the player can equip in their weapon slot, damages enemies
  int damageMod;
  Weapon({String itemName='Unknowable Item', 
    int value=0, 
    String rarity='common', 
    bool sellable=true, 
    var modifiers, 
    this.damageMod=0}): 
  super(itemName: itemName, // inherits from Item
    rarity: rarity, 
    value: value, 
    sellable: sellable, 
    modifiers: modifiers);
}