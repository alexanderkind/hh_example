import 'package:hh_example/common/models/task_status/task_statuses.dart';
import 'package:hh_example/common/utils/default_serializer.dart';
import 'package:hh_example/common/utils/extensions/date_extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tasks.freezed.dart';
part 'tasks.g.dart';

@freezed
class GroupTasksByDate with _$GroupTasksByDate {
  /// Создать отсортированный список групп с заданиями
  static List<GroupTasksByDate> fromTasks(List<Task> tasks) {
    /// Сортировка задач по дате ASC
    tasks.sort((a, b) => a.datetime.compareTo(b.datetime));
    final groups = <GroupTasksByDate>[];

    for (final task in tasks) {
      late GroupTasksByDate group;

      if (groups.lastOrNull?.date.toDefaultDateFormat() == task.datetime.toDefaultDateFormat()) {
        /// Если группа есть под задачу, то берём её
        group = groups.last;
      } else {
        /// Если нет, то создаём её
        final date = task.datetime;
        groups.add(GroupTasksByDate(
          date: DateTime(date.year, date.month, date.day),
          tasks: [],
        ));
        group = groups.last;
      }

      /// Заменяем задачу в группе
      group = group.copyWith(tasks: [...group.tasks, task]);
      groups.setAll(groups.length - 1, [group]);
    }

    return groups;
  }

  const GroupTasksByDate._();

  const factory GroupTasksByDate({
    required DateTime date,
    required List<Task> tasks,
  }) = _DateTasks;

  factory GroupTasksByDate.fromMapEntry(MapEntry<String, dynamic> entry) {
    final date = DateTime.parse(entry.key);
    final tasks = (entry.value as List<dynamic>).map((e) => Task.fromJson(e)).toList();

    return GroupTasksByDate(
      date: date,
      tasks: tasks,
    );
  }

  /// Кол-во пассажиров по задачам
  int get transfersCount => tasks.map((e) => e.data.length).fold(0, (p, v) => p + v);

  /// Максимальное кол-во бустеров по задачам
  int get maxBoosterSeatCount => tasks.fold(0, (p, v) {
        final newCount = v.boosterSeatCount;
        return p > newCount ? p : newCount;
      });

  /// Максимальное кол-во детских кресел по задачам
  int get maxChildSeatCount => tasks.fold(0, (p, v) {
        final newCount = v.childSeatCount;
        return p > newCount ? p : newCount;
      });

  /// Все статусы задач
  Set<LocalTaskStatus> get localTaskStatuses => tasks.map((e) => e.localStatus).toSet();
}

@freezed
class Task with _$Task {
  const Task._();

  const factory Task({
    required DateTime datetime,
    @Default(TaskStatus.newStatus)
    @JsonKey(fromJson: TaskStatus.fromJson, toJson: TaskStatus.toJson)
    TaskStatus status,
    @Default(-1) @JsonKey(fromJson: DefaultSerializer.intFromJson) int marketStatus,
    @Default(0.0) @JsonKey(fromJson: DefaultSerializer.doubleFromJson) double salary,
    @Default(0.0) @JsonKey(fromJson: DefaultSerializer.doubleFromJson) double penalty,
    @Default(false) bool isExpanded,
    // TODO(lexanderkind): Исправить, не может быть null
    String? from,
    // TODO(lexanderkind): Исправить, не может быть null
    String? to,
    @Default([]) List<Transfer> data,
  }) = _Task;

  factory Task.fromJson(Map<String, Object?> json) => _$TaskFromJson(json);

  factory Task.fake() {
    final date = DateTime(2024);

    return Task(
      datetime: date,
      data: [
        Transfer.fake(),
      ],
    );
  }

  /// СТАТУСЫ
  ///
  /// Локальный статуса
  LocalTaskStatus get localStatus => LocalTaskStatus.valueByTask(this);

  /// ТРАНСФЕРЫ [Transfer]
  ///
  /// Активный трансфер, совпадающий по статусу с задачей
  Transfer get activeTransfer =>
      data.where((e) => e.localStatus == localStatus).firstOrNull ?? data.first;

  /// Активный трансфер, совпадающий по статусу с задачей
  int get activeIndexTransfer => data.indexOf(activeTransfer);

  /// Получение списка трансферов, которые нужно начать
  List<Transfer> get nextTransfersForOpened =>
      data.where((e) => e.status == TaskStatus.newStatus).toList();

  /// Получение списка трансферов, которые нужно начать
  List<Transfer> get nextTransfersForStarted =>
      data.where((e) => e.status == TaskStatus.opened).toList();

  /// Получение списка трансферов с ближайшим местом встречи
  List<Transfer> get nextTransfersForDriverArrived {
    final transfers = data.where((e) => e.status == TaskStatus.opened && e.driverToPickUp).toList();
    final currentPickUp = transfers.first.pickUp;
    transfers.removeWhere((e) => e.pickUp != currentPickUp);

    return transfers;
  }

  /// Получение списка трансферов для посадки пассажиров
  List<Transfer> get nextTransfersForClientOnBoard =>
      data.where((e) => e.status == TaskStatus.opened && e.driverWaiting).toList();

  /// Получение списка трансферов с ближайшим местом высадки
  List<Transfer> get nextTransfersForComplete {
    final transfers = data.where((e) => e.status == TaskStatus.started && e.clientOnBoard).toList();
    final currentDropOff = transfers.firstOrNull?.dropOff;
    transfers.removeWhere((e) => e.dropOff != currentDropOff);

    return transfers;
  }

  /// Идентиифкаторы трснсферов
  List<int> get transferIds => data.map((e) => e.id).toList();

  /// Идентиифкаторы заданий
  List<int> get taskIds => data.map((e) => e.taskId).toList();

  /// МЕСТА [TransferPlace]
  ///
  /// Все места посадки
  List<TransferPlace> get pickUpPlaces => data.map((e) => e.pickUp).toSet().toList();

  /// Все места высадки
  List<TransferPlace> get dropOffPlaces => data.map((e) => e.dropOff).toSet().toList();

  /// Список корректных мест посадки
  List<TransferPlace> get pickUpCorrectPlaces =>
      pickUpPlaces.where((e) => e.hasCoordinates).toList();

  /// Список корректных мест высадки
  List<TransferPlace> get dropOffCorrectPlaces =>
      dropOffPlaces.where((e) => e.hasCoordinates).toList();

  List<TransferPlace> get allCorrectPlaces => [...pickUpCorrectPlaces, ...dropOffCorrectPlaces];

  /// Список мест, которые ещё не пройдены
  List<TransferPlace> get currentActivePlaces {
    final pickUpPlaces = <TransferPlace>{};
    final dropOffPlaces = <TransferPlace>{};

    if (localStatus == LocalTaskStatus.completed) {
      return allCorrectPlaces;
    }

    for (final t in data) {
      if (t.localStatus == LocalTaskStatus.completed) {
        continue;
      }

      /// Если клиент ещё не на борту, то нужно добавить точку посадки
      if (!t.clientOnBoard && t.pickUp.hasCoordinates) {
        pickUpPlaces.add(t.pickUp);
      }

      /// Если трансфер ещё не завершён, то добавляем точку высадки
      if (t.dropOff.hasCoordinates) {
        dropOffPlaces.add(t.dropOff);
      }
    }

    return [...pickUpPlaces, ...dropOffPlaces];
  }

  /// ОСТАЛЬНОЕ
  ///
  /// Флаг проблем с данными
  bool get hasProblems =>
      pickUpPlaces.where((e) => !e.hasCoordinates).isNotEmpty ||
      dropOffPlaces.where((e) => !e.hasCoordinates).isNotEmpty;

  /// ID первого трансфера задачи
  int get firstTransferId => data.first.id;

  /// Флаг путешествия с лыжами
  String get firstReference => data.first.reference;

  /// Кол-во пассажиров по трансферам
  int get passengerCount => data.fold(0, (pv, v) => pv + v.passengerCount);

  /// Кол-во бустеров по трансферам
  int get boosterSeatCount => data.fold(0, (pv, v) => pv + v.boosterSeatCount);

  /// Кол-во детских кресел по трансферам
  int get childSeatCount => data.fold(0, (pv, v) => pv + v.childSeatCount);

  /// Флаг путешествия с лыжами
  bool get withSkis => data.any((e) => e.travelingWithSkis);

  /// Флаг определения совместного трансфера
  bool get isShared => pickUpCorrectPlaces.length > 1 || dropOffCorrectPlaces.length > 1;

  /// Флаг определения раздельного трансфера
  bool get isSplit => data.map((e) => e.otherDrivers).any((e) => e.isNotEmpty);

  /// Максимальная задержка рейса по трансферам
  int? get maxFlightDelay {
    final delays = data.map((e) => e.flight?.delay ?? 0).where((e) => e > 0).toSet();

    if (delays.isEmpty) {
      return null;
    }

    return delays.reduce((p, n) => p > n ? p : n);
  }

  /// Все таблички
  Set<String> get signs => data.map((e) => e.sign).toSet();

  /// Все другие водители из трансферов
  Set<TransferDriver> get otherDrivers =>
      data.map((e) => e.otherDrivers).reduce((p, n) => [...p, ...n]).toSet();

  /// Сумма чаевых по всем трансферам заданий
  double get tipAmount =>
      data.map((e) => e.tipAmount).whereType<double>().fold(0.0, (p, e) => p + e);

  List<String> get clientInfos =>
      data.map((e) => e.clientInfo).whereType<String>().where((e) => e.isNotEmpty).toList();

  String get clientInfoSequence => clientInfos.join(', ');
}

@freezed
class Transfer with _$Transfer {
  const Transfer._();

  const factory Transfer({
    @Default('') String key,
    @Default('') String region,
    @Default('') String reference,
    String? sharedGroupId,
    DateTime? sharedGroupDatetime,
    String? sharedIndex,
    @JsonKey(fromJson: DefaultSerializer.intFromJson) required int taskId,
    @JsonKey(fromJson: DefaultSerializer.intFromJson) required int rideId,
    required DateTime taskDate,
    required DateTime datetime,
    required DateTime bookingDatetime,
    @Default(TaskStatus.newStatus)
    @JsonKey(fromJson: TaskStatus.fromJson, toJson: TaskStatus.toJson)
    TaskStatus status,
    @JsonKey(fromJson: DefaultSerializer.stringTrimmedFromJson) required String leadPassenger,
    required String agency,
    required String contactNumber,
    String? flightNumber,
    DateTime? flightDatetime,
    TransferFlight? flight,
    @Default(0) @JsonKey(fromJson: DefaultSerializer.intFromJson) int passengerCount,
    @Default(0) @JsonKey(fromJson: DefaultSerializer.intFromJson) int childSeatCount,
    @Default(0) @JsonKey(fromJson: DefaultSerializer.intFromJson) int boosterSeatCount,
    @Default(false) @JsonKey(fromJson: DefaultSerializer.boolFromJson) bool travelingWithSkis,
    @Default(false) @JsonKey(fromJson: DefaultSerializer.boolFromJson) bool isFromResort,
    @Default(false) @JsonKey(fromJson: DefaultSerializer.boolFromJson) bool isToResort,
    @Default(false) @JsonKey(fromJson: DefaultSerializer.boolFromJson) bool isFromStation,
    @Default(false) @JsonKey(fromJson: DefaultSerializer.boolFromJson) bool isToStation,
    required TransferPlace pickUp,
    required TransferPlace dropOff,
    TransferPlace? accommodation,
    @Default(false) bool isDelivery,
    @JsonKey(fromJson: DefaultSerializer.stringTrimmedFromJson) required String sign,
    String? adminInfo,
    String? clientInfo,
    @Default('') String serviceInfo,
    String? infoPage,
    @Default(0.0) @JsonKey(fromJson: DefaultSerializer.doubleFromJson) double cashAmount,
    @JsonKey(fromJson: DefaultSerializer.intFromJsonNullable) int? loyaltyUserId,
    TransferPlace? station,
    TransferPlace? resort,
    @JsonKey(fromJson: DefaultSerializer.doubleFromJsonNullable) double? tipAmount,
    @JsonKey(fromJson: DefaultSerializer.intFromJson) required int id,
    @Default(false) bool driverToPickUp,
    @Default(false) bool driverWaiting,
    @Default(false) bool clientOnBoard,
    @Default(false) bool clientOnBoardAssistant,
    @Default(false) bool clientNoShow,
    @Default(false) bool clientNoShowAssistant,
    @Default(0) @JsonKey(fromJson: DefaultSerializer.intFromJson) int skiStorageStatus,
    @Default(0) @JsonKey(fromJson: DefaultSerializer.intFromJson) int skiRentalStatus,
    String? skiShop,
    String? marketStatus,
    @Default(0.0) @JsonKey(fromJson: DefaultSerializer.doubleFromJson) double salary,
    @Default(0.0) @JsonKey(fromJson: DefaultSerializer.doubleFromJson) double penalty,
    @Default([]) List<dynamic> attachments,
    @Default(false) bool signAttached,
    required String signHtml,
    @Default([]) List<TransferDriver> otherDrivers,
  }) = _Transfer;

  factory Transfer.fromJson(Map<String, Object?> json) => _$TransferFromJson(json);

  factory Transfer.fake() {
    final date = DateTime(2024);
    return Transfer(
      taskId: 0,
      rideId: 0,
      taskDate: date,
      datetime: date,
      bookingDatetime: date,
      leadPassenger: 'Mr Russell McIndoe',
      agency: 'Holiday Taxis Ltd.',
      contactNumber: '+444444444444',
      flightNumber: 'E3E2E1',
      flightDatetime: date,
      flight: TransferFlight.fake(),
      pickUp: TransferPlace.fake(),
      dropOff: TransferPlace.fake(),
      accommodation: TransferPlace.fake(),
      sign: 'Mr Russell McIndoe',
      loyaltyUserId: 0,
      id: 0,
      signHtml: 'Mr Russell McIndoe',
    );
  }

  LocalTaskStatus get localStatus => LocalTaskStatus.valueByTransfer(this);

  /// Запасная точка встречи с пассажиром
  TransferPlace? get backupPickUp => isFromResort ? resort : station;

  TransferPlace get pickUpWithBackupCoordinates {
    final backupPickUp = this.backupPickUp;

    return pickUp.copyWith(lat: backupPickUp?.lat, lng: backupPickUp?.lng);
  }

  /// Запасная точка высадки пассажира
  TransferPlace? get backupDropOff => isToResort ? resort : station;

  TransferPlace get dropOffWithBackupCoordinates {
    final backupDropOff = this.backupDropOff;

    return dropOff.copyWith(lat: backupDropOff?.lat, lng: backupDropOff?.lng);
  }
}

@freezed
class TransferFlight with _$TransferFlight {
  const TransferFlight._();

  const factory TransferFlight({
    required String number,
    required DateTime datetime,
    @Default(0) @JsonKey(fromJson: DefaultSerializer.intFromJson) int delay,
    String? status,
  }) = _TransferFlight;

  factory TransferFlight.fromJson(Map<String, Object?> json) => _$TransferFlightFromJson(json);

  factory TransferFlight.fake() => TransferFlight(
        number: 'EEE222',
        delay: 1,
        datetime: DateTime(2024),
      );

  String get numberAndTime => '$number, ${datetime.toHhmmFormat()}';
}

@freezed
class TransferPlace with _$TransferPlace {
  const TransferPlace._();

  const factory TransferPlace({
    required String name,
    String? shortName,
    @JsonKey(fromJson: DefaultSerializer.stringTrimmedFromJson) required String address,
    // TODO(lexanderkind): Исправить, не может быть null
    @Default(null) @JsonKey(fromJson: DefaultSerializer.doubleFromJson) double? lat,
    // TODO(lexanderkind): Исправить, не может быть null
    @Default(null) @JsonKey(fromJson: DefaultSerializer.doubleFromJson) double? lng,
  }) = _TransferPlace;

  factory TransferPlace.fromJson(Map<String, Object?> json) => _$TransferPlaceFromJson(json);

  factory TransferPlace.fake() => const TransferPlace(
        name: 'Lake Geneva Hotel',
        address: 'Rte de Suisse 79, 1290 Versoix, Switzerland',
        lat: 0,
        lng: 0,
      );

  bool get hasCoordinates => lat != null && lng != null;

  String get separatedByCommasLatLng => hasCoordinates ? '$lat, $lng' : '';

  String get priorityAddress {
    if (address.isNotEmpty) {
      return address;
    } else if (name.isNotEmpty) {
      return name;
    }

    return '';
  }

  String get valueForCopy {
    var value = separatedByCommasLatLng;

    if (value.isNotEmpty) {
      return value;
    }

    return priorityAddress;
  }
}

@freezed
class TransferDriver with _$TransferDriver {
  const TransferDriver._();

  const factory TransferDriver({
    @Default('') String firstName,
    @Default('') String lastName,
    @Default('') String phoneNumber,
  }) = _TransferDriver;

  factory TransferDriver.fromJson(Map<String, Object?> json) => _$TransferDriverFromJson(json);

  String get fullName => '${firstName.trim()} ${lastName.trim()}'.trim();
}
