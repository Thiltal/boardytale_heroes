import 'dart:async';
import 'package:angular/src/core/metadata.dart';
import 'package:angular/src/common/directives/core_directives.dart';
import 'package:angular_forms/src/directives.dart';
import 'package:boardytale_heroes/src/services/items_service.dart';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

@Component(
  selector: 'buttoned-input',
  template: '''
  <button *ngIf="decimal" (click)="decreaseDecimal()">--</button>
  <button (click)="decrease()">-</button>
  {{value}}
  <button (click)="increase()">+</button>
  <button *ngIf="decimal" (click)="increaseDecimal()">++</button>
  ''',
  directives: const [
    CORE_DIRECTIVES,
    formDirectives
  ],
  providers: const [ItemsService],
)
class ButtonedNumberInputComponent {
  int _value = 1;

  int get value => _value;

  @Input("value")
  void set value(int val) {
    _value = val;
  }

  final _valueChange = new StreamController<int>();
  @Output()
  Stream<int> get valueChange => _valueChange.stream;

  @Input("decimal")
  bool decimal = false;

  void increase() {
    _value++;
    _valueChange.add(_value);
  }

  void decrease() {
    _value--;
    _valueChange.add(_value);
  }

  void increaseDecimal() {
    _value = _value + 10;
    _valueChange.add(_value);
  }

  void decreaseDecimal() {
    _value = _value - 10;
    _valueChange.add(_value);
  }
}
