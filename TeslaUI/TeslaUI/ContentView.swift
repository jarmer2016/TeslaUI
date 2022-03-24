//
//  ContentView.swift
//  TeslaUI
//
//  Created by James Armer on 03/11/2021.
//


import SwiftUI
import MapKit
import CoreLocation
import CoreBluetooth


public var multiplierThing: String = ""
public var valueThing: String = ""
public var speedLabelShown: Int = 0

public var scalesValue: Int = 0

public var arrayIndex = 0

public var arrayOfSpeed: [Int] = []

public var lastValue: Int = 0
public var currentValue: Int = 0

protocol BluetoothManagerDelegate: AnyObject {
    func didErrorReceived(manager: NSObject)
    func didSensorReceived(data: Data, rssi: Int)
}

class BluetoothManager: NSObject, ObservableObject {
    
    var centralManager: CBCentralManager!
    weak var delegate: BluetoothManagerDelegate?

    @Published var isSwitchedOn = false
    
    
    @Published var weightInKG: Float = 0
    
    let kCBAdvDataManufacturerData = "kCBAdvDataManufacturerData"
    let kCBAdvDataLocalName        = "kCBAdvDataLocalName"

    override init() {
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager.delegate = self
    }

    func start() {
        self.centralManager = CBCentralManager(delegate: self, queue: DispatchQueue(label: "com.albertopasca.blequeue"))
    }

    func stop() {
        self.centralManager.stopScan()
    }

}

extension BluetoothManager: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            isSwitchedOn = false
            delegate?.didErrorReceived(manager: self)
        } else {
            isSwitchedOn = true
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    //In future, create an updateSpeed function to smoothly increase to speed from accelerator/scales
    func updateSpeed() {
        
    }

    

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {

        
        if peripheral.identifier == UUID(uuidString: "239A64D9-2E78-AAA8-00A0-72F4E5343963") {
            
            if let manufacturerData = advertisementData["kCBAdvDataManufacturerData"] as? Data {

                    let packetCounter6 = UInt16(manufacturerData[18]) << 8 + UInt16(manufacturerData[19])
                    print(String(format: "%02X", packetCounter6)) //->32

                valueThing = String(format: "%02X", packetCounter6)

                valueThing.remove(at: valueThing.startIndex)

                let decimalValueThing = UInt16(valueThing, radix: 16) ?? 0
               print(valueThing)

                // 255 multiplyer thing
                    let packetCounter7 = UInt16(manufacturerData[20])
                    print(String(format: "%02X", packetCounter7)) //->32


                multiplierThing =  String(format: "%02X", packetCounter7)

                let multiplierNumber = UInt16(multiplierThing, radix: 16) ?? 0


                    let packetCounter8 = UInt16(manufacturerData[21]) << 8 + UInt16(manufacturerData[22])
                    print(String(format: "%02X", packetCounter8)) //->32

                var convertToFloat = Float((multiplierNumber * 256) + decimalValueThing)

                weightInKG = convertToFloat

//                weightInKG = weightInKG     //this was originially divided by 100 to get the weight into 10s of grams
                
                scalesValue = Int(weightInKG)
                
                arrayOfSpeed.append(scalesValue)
                
//                arrayIndex += 1
//
//                currentValue = arrayOfSpeed[arrayIndex]
//
//                if arrayIndex == 1 {
//                    lastValue = 0
//                } else {
//                    lastValue = arrayOfSpeed[arrayIndex - 1]
//                }
//
                

//                updateSpeed()
                print("speedlabel shown: \(speedLabelShown)")

                print("The weight is \((convertToFloat))kg")

            }

        print(peripheral.identifier)
            print(advertisementData["kCBAdvDataManufacturerData"])
            
            print(arrayOfSpeed)
        
        }
    }
}



//
//func updateSpeed() {
//    if scalesValue > 0 && scalesValue > speedLabelShown {
//        speedLabelShown += 1
//    }
//}






struct ContentView: View {
  


    
    var body: some View {
                
        
        leftView()
            .statusBar(hidden: true)
            .background(Color.black)
    }
}


struct leftView: View {
    
//    @State var locationManager = CLLocationManager()
    
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @State var milesRange: Int = 247
    
    @State var currentSpeed : Double = 0
    
    @ObservedObject var bleManager = BluetoothManager()

    

    //locationManager.desiredAccuracy = kCLLocationAccuracyBest
    
    var body: some View {
        
        var kgWeight = $bleManager.weightInKG

        var valueConvert = Int(kgWeight.wrappedValue)
//        var multiplyValue = Int(kgWeight.wrappedValue) / 10
        
      
        
        var scalesSpeed = valueConvert / 10 //* multiplyValue
        
        
        
        
        VStack{
            
            HStack{
                VStack{
                    
                    
                    
                    HStack{
                        Image(systemName: "safari")
                            .hidden()
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity)
                        
                        Image(systemName: "safari")
                            .hidden()
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity)
                        
                        Image(systemName: "safari")
                            .hidden()
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity)
                        
                        Image(systemName: "safari")
                            .hidden()
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity)
                        
                        Image(systemName: "safari")
                            .hidden()
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity)
                        
                        Image(systemName: "safari")
                            .hidden()
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity)
                        
                        Image(systemName: "safari")
                            .hidden()
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity)
                        
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    
                    
//                    if bleManager.isSwitchedOn {
//                        Text("Bluetooth is switched on")
//                            .foregroundColor(.green)
//
//                        Text(textConvert + "kg")
//                            .foregroundColor(.green)
//                            .font(.system(size: 80))
//                    }
//                    else {
//                        Text("Bluetooth is NOT switched on")
//                            .foregroundColor(.red)
//                    }
                    
////                    Text("\(Int(currentSpeed))")
                
                    
                    
                    
                    Text("\(scalesSpeed)")
                        .font(.system(size: 80))
                        .frame(maxHeight: 100, alignment: .topLeading)
                        .foregroundColor(Color.black)
//
                    
                    
                    
                    
                   
                    
                    
                    
                    
                    
                    HStack{
                        
                        // Gear Selection...
                        HStack{
                            
                            Text("P")
                                .foregroundColor(currentSpeed > 0 ? Color.gray : Color.black)
                            
                            Text("R")
                                .foregroundColor(Color.gray)
                            
                            
                            Text("N")
                                .foregroundColor(Color.gray)
                            
                            Text("D")
                                .foregroundColor(currentSpeed == 0 ? Color.gray : Color.black)
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Speed Measurment...
                        Text("MPH")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.gray)
                        
                        
                        
                        // Range and Battery Indicator...
                        HStack{
                            
                            Text("\(milesRange) mi")
                                .foregroundColor(Color.gray)
                            
                            Image(systemName: "battery.75")
                                .foregroundColor(Color.gray)
                                
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing)
                        
                        
                        
                        
                       
                            
                        
                        
                        
                    }
                    
                    HStack{
                        
                        Image(systemName: "circle.inset.filled")
                            .font(.system(size: 40))
                            .foregroundColor(Color.blue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 25)
                        
//                        Image(systemName: "safari")
//                            .foregroundColor(Color.gray)
//                            .frame(maxWidth: .infinity)
                        
                        HStack{
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "minus")
                                    .foregroundColor(Color.black)
                                    .padding()
                            }

                            Image(systemName: "safari")
                                .font(.system(size: 40))
                                .foregroundColor(Color.black)
                                .padding()
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "plus")
                                    .foregroundColor(Color.black)
                                    .padding()
                            }

                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack{

                            Text("SPEED \nLIMIT")
                                .font(.system(size: 10))
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .padding([.top, .leading, .trailing], 2)
                                .foregroundColor(Color.black)

                            Text("65")
                                .fontWeight(.bold)
                                .padding(.bottom, 2)
                                .foregroundColor(Color.black)

                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .frame(minHeight: 60)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                        
                        
                        
                    }
                    .padding()
                    
                    
                    
                    
                    Image("TeslaAutoDisplay")
                        .resizable()
                        .scaledToFit()
                        
                    
                    Spacer()
                       
                    
                    HStack{
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "smallcircle.filled.circle")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 30))
                                .frame(maxWidth: .infinity)
                        }

                        Button {
                            
                        } label: {
                            Image(systemName: "bolt.fill")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 30))
                                .frame(maxWidth: .infinity)
                        }

                        Button {
                            
                        } label: {
                            Image(systemName: "mic.fill")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 30))
                                .frame(maxWidth: .infinity)
                            
                        }

                        
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding([.leading, .trailing], 50)
                    
                    Spacer()
                       
                    
                    Slider(value: $currentSpeed, in: 0...160, step: 1)
                        .padding(50)
                    
                    
                    
                }
                .frame(maxWidth: UIScreen.main.bounds.width / 3, maxHeight: .infinity, alignment: .center)
                .background(Color("TeslaLightGray"))
                .cornerRadius(10)
                .padding([.top, .bottom, .leading])
                .ignoresSafeArea()
                
                ZStack{
                
                Map(coordinateRegion: $region, showsUserLocation: true)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .cornerRadius(10)
                    .padding([.top, .bottom, .trailing])
                    .ignoresSafeArea()
                
                    HStack{
                    
                    VStack{
                        
                        Button{
                            
                        } label: {
                            HStack{
                            
                            Image(systemName: "location")
                                    .font(.system(size: 25))
                                    .foregroundColor(Color.gray)
                                    .padding()
                                
                            Text("Navigate")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color.gray)
                                    .frame(alignment: .trailing)
                                    .padding()
                                
                                
                            }
                            .frame(width: 300, height: 50)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                            .padding(.leading)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5)
                            .foregroundColor(Color.black)
                            
                        }
                        
                        
//                        HStack{
//
//                        Image(systemName: "location")
//                                .font(.system(size: 25))
//                                .foregroundColor(Color.gray)
//                                .padding()
//
//                        Text("Navigate")
//                                .font(.system(size: 20))
//                                .foregroundColor(Color.gray)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//
//                            Image(systemName: "chevron.right")
//                                .font(.system(size: 20))
//                                .foregroundColor(Color.gray)
//                                .frame(alignment: .trailing)
//                                .padding()
//
//
//                        }
//                        .frame(width: 300, height: 50)
//                        .background(Color.white.opacity(0.8))
//                        .cornerRadius(10)
//                        .padding(.leading)
//                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
//                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5)
//                        .foregroundColor(Color.black)
                        
                        Text("Destination Steps")
                            .frame(width: 300, height: 750)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding([.leading, .top])
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5)
                            .foregroundColor(Color.black)
                            .hidden()
                    }
                    
                        Spacer()
                        
                        
                    }
                }
                
//                VStack{
//
//                    Text("Hello World")
//
//                }
//                .frame(maxWidth: UIScreen.main.bounds.width / 3 * 1.8, maxHeight: .infinity, alignment: .center)
//                .background(Color.gray)
//                .cornerRadius(10)
//                .padding([.top, .bottom])
//                .ignoresSafeArea()
//
            }
            
            HStack(alignment: .center, spacing: 100){
                
                Button {
                    
                } label: {
                    Image(systemName: "car.fill")
                        .font(.title)
                        .foregroundColor(Color.white)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "music.note")
                        .font(.title)
                        .foregroundColor(Color.white)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "chevron.up.square")
                        .font(.title)
                        .foregroundColor(Color.white)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "thermometer.sun")
                        .font(.title)
                        .foregroundColor(Color.white)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "fanblades.fill")
                        .font(.title)
                        .foregroundColor(Color.white)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "safari")
                        .font(.title)
                        .foregroundColor(Color.white)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "camera.fill")
                        .font(.title)
                        .foregroundColor(Color.white)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "bolt.fill")
                        .font(.title)
                        .foregroundColor(Color.white)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.title)
                        .foregroundColor(Color.white)
                }
                
                

            }
            .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.05, alignment: .center)
            .background(Color.black)
            .cornerRadius(10)
            .padding(.top, -10)
            .padding([.leading, .trailing], 15)
            
            
            
            
        }
        
    }
  
   
}

struct SpeedoView: View {

    @State public var percent: CGFloat = 0
    
    var body: some View {
        Text("")
            .frame(width: 500, height: 500)
            .foregroundColor(.black)
            .modifier(AnimatingNumberOverlay(number: percent))
        
        Button {
            withAnimation(Animation.easeInOut(duration: 1)) {
                
                percent = 20
            }
        } label: {
            Text("Animate")
        }

    }
    
}

struct AnimatingNumberOverlay: AnimatableModifier {
    var number: CGFloat
    var animatableData: CGFloat {
        get {
            number
        }
        
        set {
            
            number = newValue
            
        }
    }
    func body(content: Content) -> some View {
        return content.overlay(Text("\(Int(number))")
                                .font(.largeTitle))
            .foregroundColor(.black)
//            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
.previewInterfaceOrientation(.landscapeLeft)
    }
}
