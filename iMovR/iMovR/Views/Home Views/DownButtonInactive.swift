import SwiftUI

struct DownButtonInactive: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    @Binding var pressed: Bool
    @Binding var unpressedTimer: Timer?
    
    var Unpressed = Image("DownButton")
    var Pressed = Image("DownButtonPressed")
    
    @State private var ButtonBG = false
    @State private var animateColor: Color = Color.white
    @State private var animateBlur: CGFloat = CGFloat(0.0)
    @State private var animateOpacity: Double = 1.0
    
    var body: some View {
        Button(action: {}) {
            (ButtonBG ? Pressed : Unpressed)
                .resizable()
                .frame(maxWidth: 100, minHeight: 90, idealHeight: 100, maxHeight: 150)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ _ in
                            ButtonBG = true
                        })
                        .onEnded({ _ in
                            ButtonBG = false
                        }))
        }
    }
}

struct DownButtonInactive_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            DownButton(data: DeviceDataManager(), pressed: .constant(false), unpressedTimer: .constant(nil))
                .environmentObject(DeviceBluetoothManager())
        }
    }
}
