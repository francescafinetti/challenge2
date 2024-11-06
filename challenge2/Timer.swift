import SwiftUI

struct ContentView2: View {
    @State private var progress: CGFloat = 0.0
    @State private var timer: Timer? = nil
    @State private var countdownTimer: Timer? = nil
    @State private var countdown: Int = 3
    @State private var selectedMinutesText: String = "0"
    @State private var selectedSecondsText: String = "10"
    @State private var selectedTime: CGFloat = 10.0
    @State private var isPaused = false
    @State private var isCountingDown = false
    let maxTime: CGFloat = 40000000.0

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 40)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 40, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 200, height: 200)
                    .animation(.linear, value: progress)
                
                if isCountingDown {
                    Text("\(countdown)")
                        .font(.system(size: 100, weight: .bold))
                        .foregroundColor(.blue)
                } else {
                    Text(timeFormatted(totalSeconds: Int((1 - progress) * selectedTime)))
                        .font(.largeTitle)
                        .bold()
                }
            }
            .padding()
            
            VStack {
                Text("Set the duration")
                    .font(.headline)
                
                HStack {
                    TextField("Minutes", text: $selectedMinutesText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .frame(width: 60)
                        .multilineTextAlignment(.center)
                    
                    Text(":")
                    
                    TextField("Seconds", text: $selectedSecondsText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .frame(width: 60)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }

            HStack {
                Button(action: startCountdown) {
                    Text("Start")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: togglePause) {
                    Text(isPaused ? "Continue" : "Pause")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .onDisappear {
            timer?.invalidate()
            countdownTimer?.invalidate()
        }
    }

    func startCountdown() {
        if let minutes = Int(selectedMinutesText), let seconds = Int(selectedSecondsText), minutes >= 0, seconds >= 0, CGFloat(minutes * 60 + seconds) <= maxTime {
            selectedTime = CGFloat(minutes * 60 + seconds)
        } else {
            selectedTime = 10.0
        }
        
        countdown = 3
        isCountingDown = true
        isPaused = false
        progress = 0.0
        countdownTimer?.invalidate()
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if countdown > 1 {
                countdown -= 1
            } else {
                countdownTimer?.invalidate()
                isCountingDown = false
                startTimer()
            }
        }
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if !isPaused && progress < 1.0 {
                progress += 0.1 / selectedTime
            } else if progress >= 1.0 {
                timer?.invalidate()
            }
        }
    }

    func togglePause() {
        if !isCountingDown {
            isPaused.toggle()
        }
    }
    
    func timeFormatted(totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
