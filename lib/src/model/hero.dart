part of boardytale.heroes.model;

class Hero {
  num id = 0;
  HeroData data = new HeroData();
  List<Item> items = new List<Item>();
  List<Ability> abilities = new List<Ability>();
  HeroOut out = new HeroOut();
  HeroCalculated calculated = new HeroCalculated();
  HeroItemSum itemSum = new HeroItemSum();
  HeroSettings settings = new HeroSettings();
  Weapon weapon = null;

  Hero() {
    recalc();
  }

  addItem([String itemData]) {
    Item item = new Item();
    item.hero = this;
    if (itemData != null) {
      item.fromMap(null);
    }
    items.add(item);
    if (item is Weapon) {
      weapon = item;
    }
    recalc();
  }

  recalc() {
    itemSum.reset();
    for (Item item in items) {
      itemSum.add(item);
    }
    calculated.takeBasic(this, itemSum);
    calculated.recalculateArmor(itemSum, out);
    calculated.recalculateSpeed(out);
    out.mana = calculated.intelligence + itemSum.manaBonus + itemSum.intelligenceBonus;
    recalcAttack();
    out.health = calculated.health;
  }

  recalcAttack() {
    double pp;
    double dmg;
    List<int> mask;
    if (weapon != null) {
      weapon.recalculate();
      calculated.suitability = (weapon.impactedSuitabilityMatch + 0.1) / 1.1;
      calculated.usability = (weapon.impactedUsabilityMatch + 0.1) / 1.1;
      pp = weapon.precision.toDouble();
      mask = weapon.mask;
      dmg = weapon.damage.toDouble();
      dmg += (weapon.agilityUse * calculated.agility) / 100;
      dmg += (weapon.strengthUse * calculated.strength) / 100;
      dmg += (weapon.intelligenceUse * calculated.intelligence) / 100;
    } else {
      pp = 0.0;
      calculated.suitability = 0;
      calculated.usability = 0;
      mask = [0, 1, 1, 1, 1, 1];
      dmg = 1.0 + calculated.strength / 7;
    }
    pp += (calculated.speedPrecisionPoints * 3).toDouble();
    pp *= 1 - calculated.suitability;
    pp *= 1 - calculated.usability;
    pp *= calculated.agility / calculated.strength;
    calculated.precisionPoints = pp;
    calculated.precision = 1;
    if (pp > 25) {
      calculated.precision = 5;
      pp -= 25;
    } else if (pp > 8) {
      calculated.precision = 4;
      pp -= 8;
    } else if (pp > 4) {
      calculated.precision = 3;
      pp -= 4;
    } else if (pp > 1) {
      calculated.precision = 2;
      pp -= 1;
    }
    calculated.unusedPrecisionPoints = pp;
    pp = sqrt(pp).floor().toDouble();
    dmg *= 1 - calculated.suitability; // desĂ­tky procent dolu
    dmg *= 1 - calculated.usability; // desĂ­tky procent dolu
//    dmg *= (calculated.strength + 100) / 100; // desĂ­tky procent nahoru
//    dmg += (calculated.strength / 4).floor();
//    dmg += (calculated.agility / 6).floor();

    dmg = dmg.floor().toDouble();

    var attack = [0, 0, 0, 0, 0, 0];

    int maskSum = 0;
    int prec = calculated.precision;
    for (var i = 0; i < prec; i++) {
      maskSum += mask[5 - i];
    }
    var normask = [0, 0, 0, 0, 0, 0];
    for (var i = 0; i < 6; i++) {
      if (i > 5 - prec) {
        normask[i] = mask[i] ~/ maskSum;
      }
    }
    for (int i = 0; i < attack.length; i++) {
      attack[i] = (dmg * normask[i]).floor();
      if (attack[i] == 0 && normask[i] > 0) {
        attack[i] = 1;
      }
    }
    int sum = 0;
    for (int i = 0; i < attack.length; i++) {
      sum += attack[i];
    }
    for (int i = 0; i < dmg - sum; i++) {
      attack[5 - i]++;
    }
    calculated.damage = dmg;
    out.attack = attack;
  }
}

class HeroSettings {
  num expAditive = 1;
  String selectedTab = "#heroWidgetOverview";
  num lastLevelMinusUsedFyzical = 0;
  num lastLevelMinusUsedMystical = 0;

  HeroSettings();
}

class HeroItemSum {
  num weight = 0;
  num armorPoints = 0;
  num healthBonus = 0;
  num manaBonus = 0;
  num strengthBonus = 0;
  num agilityBonus = 0;
  num intelligenceBonus = 0;

  HeroItemSum();

  reset() {
    weight = 0;
    armorPoints = 0;
    healthBonus = 0;
    manaBonus = 0;
    strengthBonus = 0;
    agilityBonus = 0;
    intelligenceBonus = 0;
  }

  add(Item item) {
    weight += item.weight;
    armorPoints += item.armorPoints;
    healthBonus += item.healthBonus;
    manaBonus += item.manaBonus;
    strengthBonus += item.strengthBonus;
    agilityBonus += item.agilityBonus;
    intelligenceBonus += item.intelligenceBonus;
  }
}

class HeroOut {
  num health = 1;
  num mana = 1;
  num range = 0;
  num armor = 0;
  List<int> attack = [0, 0, 0, 1, 2, 3];
  num speed = 1;

  HeroOut();

  get shealth => health.toString();

  get attackString => attack.toString();

  operator [](item) {
    switch (item) {
      case "health":
        return health;
      case "mana":
        return mana;
      default:
        return armor;
    }
  }
}