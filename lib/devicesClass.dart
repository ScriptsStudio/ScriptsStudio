class Device {
  String address;
  String name;

  Device(this.address, this.name);

  factory Device.fromJson(dynamic json) {
    return Device(json['address'] as String, json['name'] as String);
  }

  @override
  String toString() {
    return '{ ${this.address}, ${this.name} }';
  }
}


