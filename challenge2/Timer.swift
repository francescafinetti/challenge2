import SwiftUI

struct TimerView: View {
    @State private var progress: CGFloat = 0.0
    @State private var timer: Timer? = nil
    @State private var countdownTimer: Timer? = nil
    @State private var countdown: Int = 3
    @State private var selectedMinutesText: String = "0"
    @State private var selectedSecondsText: String = "10"
    @State private var selectedTime: CGFloat = 10.0
    @State private var isPaused = false
    @State private var isCountingDown = false
    @State private var isTimerRunning = false
    let maxTime: CGFloat = 40000000.0

    var body: some View {
        VStack(spacing: 20) {
//            Text("Timer")
//                .font(.title)
//                .fontWeight(.bold)
//                .padding(.top, -50)
//                
            ZStack {
                Circle()
                    .stroke(Color(red: 0.90, green: 0.90, blue: 0.90), lineWidth: 40)
                    .frame(width: 200, height: 200)
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
                
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
            .padding(100)
            
            VStack {
                Text("Set the duration")
                    .font(.headline)
                
                HStack {
                    TextField("Minutes", text: $selectedMinutesText)
                        .keyboardType(.numberPad)
                        .frame(width: 60)
                        .multilineTextAlignment(.center)
                    
                    Text(":")
                    
                    TextField("Seconds", text: $selectedSecondsText)
                        .keyboardType(.numberPad)
                        .frame(width: 60)
                        .multilineTextAlignment(.center)
                }
                .padding(15)
            }

            HStack {
                Button(action: isTimerRunning ? stopTimer : startCountdown) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .frame(width: 120, height: 50)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                        
                        Text(isTimerRunning ? "Cancel" : "Start")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)
                    }.offset(x: -20, y: 0)
                }
                
                Button(action: togglePauseOrContinue) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .frame(width: 120, height: 50)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                        
                        Text(isPaused ? "Resume" : "Pause")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.red)
                    }.offset(x: 20, y: 0)
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
        isTimerRunning = true
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
                isTimerRunning = false
            }
        }
    }

    func togglePauseOrContinue() {
        if isPaused {
            isPaused = false
            startTimer()
        } else {
            isPaused = true
            timer?.invalidate()
        }
    }

    func stopTimer() {
        timer?.invalidate()
        countdownTimer?.invalidate()
        isTimerRunning = false
        isPaused = false
        isCountingDown = false
        progress = 0.0
        countdown = 3
    }
    
    func timeFormatted(totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
