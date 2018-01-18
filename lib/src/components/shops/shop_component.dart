import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:boardytale_heroes/src/components/heroes/edit_component.dart';
import 'package:boardytale_heroes/src/components/items/item_preview_component.dart';
import 'package:boardytale_heroes/src/components/items/new_item_component.dart';
import 'package:boardytale_heroes/src/components/items/new_weapon_component.dart';
import 'package:boardytale_heroes/src/model/model.dart';
import 'package:boardytale_heroes/src/services/heroes_service.dart';
import 'package:boardytale_heroes/src/services/items_service.dart';
import 'package:boardytale_heroes/src/services/shops_service.dart';

@Component(
  selector: 'edit-shop',
  template: '''
  <h1>Nový obchod</h1>
  Jméno: <input [(ngModel)]="shopsService.selected.name"><br>
  Popis: <input [(ngModel)]="shopsService.selected.description"><br>
  
  <div *ngFor="let item of shopsService.selected.items.keys">{{item.name}}</div>
  
  <button (click)="createShop()">{{shopsService.selected.id == null? "Vytvoř nový obchod": "Uprav obchod"}}</button>
  ''',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
    materialNumberInputDirectives,
    formDirectives,
  ],
)
class ShopsComponent {
  final ShopsService shopsService;
  ShopsComponent(
    this.shopsService,
  );

  void createShop(){
    shopsService.createShop(shopsService.selected);
    shopsService.selected = null;
  }
}
