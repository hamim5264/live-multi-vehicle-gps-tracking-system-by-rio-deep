import '../models/vehicle.dart';
const List<Vehicle> sampleVehicles = [
  Vehicle(id:'1',name:'Toyota Hilux', number:'ABC-1234',type:'Truck',       speed:65,status:VehicleStatus.online, distance:'124 km',lastUpdated:'2 min ago', driver:'Rahul Ahmed',  avatar:'RA'),
  Vehicle(id:'2',name:'Honda CG 125', number:'XYZ-5678',type:'Motorcycle',  speed:42,status:VehicleStatus.online, distance:'87 km', lastUpdated:'1 min ago', driver:'Karim Hossain',avatar:'KH'),
  Vehicle(id:'3',name:'Bajaj RE Auto',number:'DEF-9012',type:'Rickshaw',    speed:0, status:VehicleStatus.offline,distance:'53 km', lastUpdated:'28 min ago',driver:'Rahim Uddin',  avatar:'RU'),
  Vehicle(id:'4',name:'Toyota Hiace', number:'GHI-3456',type:'Delivery Van',speed:58,status:VehicleStatus.online, distance:'198 km',lastUpdated:'3 min ago', driver:'Sabbir Khan',  avatar:'SK'),
  Vehicle(id:'5',name:'Suzuki APV',   number:'JKL-7890',type:'Car',         speed:0, status:VehicleStatus.idle,   distance:'32 km', lastUpdated:'15 min ago',driver:'Farhan Ali',   avatar:'FA'),
];
const List<String> vehicleTypes = ['Car','Motorcycle','Rickshaw','CNG','Delivery Van','Truck'];
const List<String> vehicleCategories = ['All','Car','Motorcycle','Rickshaw','CNG','Delivery'];
const List<Map<String,String>> activityFeed = [
  {'time':'08:15 AM','action':'Tracking started','location':'Mirpur, Dhaka',    'type':'start'},
  {'time':'10:30 AM','action':'Trip completed',  'location':'Uttara → Gulshan', 'type':'done'},
  {'time':'12:45 PM','action':'Fuel stop',        'location':'Gulshan, Dhaka',   'type':'warn'},
  {'time':'02:20 PM','action':'Trip completed',  'location':'Motijheel, Dhaka', 'type':'done'},
  {'time':'04:00 PM','action':'Break — 15 mins', 'location':'Dhanmondi, Dhaka', 'type':'warn'},
];
