//
//  SoundView.swift
//  HoundSoundV5
//
//  Created by Yuri Sung on 2/9/23.
//

import SwiftUI
import AVKit

struct SoundView: View {
    @State var audioPlayer: AVAudioPlayer!
    @State var progress: CGFloat = 0.0
    @State private var playing: Bool = false
    @State var duration: Double = 0.0
    @State var formattedDuration: String = ""
    @State var formattedProgress: String = "00:00"
    
    var body: some View {
        VStack {
            Image("houndSound")
                .padding()
            Text("Hound Sound by Team TSA* @ Pope High School")
                .bold()
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundColor(Color.blue)
                .minimumScaleFactor(0.75)
                .padding()
            HStack {
                Text(formattedProgress)
                    .font(.caption.monospacedDigit())
                    .foregroundColor(Color.blue)
                GeometryReader { gr in
                    Capsule()
                        .stroke(Color.blue, lineWidth: 2)
                        .background(
                            Capsule()
                                .foregroundColor(Color.blue)
                                .frame(width: gr.size.width * progress, height: 8), alignment: .leading
                        )
                }
                .frame( height:8 )
                Text(formattedDuration)
                    .font(.caption.monospacedDigit())
                    .foregroundColor(Color.blue)
            }
            .padding()
            .frame(height: 50, alignment: .center)
            .accessibilityElement(children: .ignore)
            .accessibility(identifier: "Hound Sound")
            .accessibilityLabel(playing ? Text("Playing at ") : Text("Duration"))
            .accessibilityValue(Text("\(formattedProgress)"))
            
            HStack(alignment: .center, spacing: 20){
                Spacer()
                Button(action: {
                    let decrease = self.audioPlayer.currentTime - 15
                    if decrease < 0.0 {
                        self.audioPlayer.currentTime = 0.0
                    } else {
                        self.audioPlayer.currentTime -= 15
                    }
                },label:{
                    Image(systemName: "gobackward.15")
                        .font(.title)
                        .imageScale(.medium)
                })
                Button(action: {
                    if audioPlayer.isPlaying {
                        playing = false
                        self.audioPlayer.pause()
                    } else if !audioPlayer.isPlaying {
                        playing = true
                        self.audioPlayer.play()
                    }
                },label:{
                    Image(systemName: playing ? "pause.circle.fill" : "play.circle.fill")
                        .font(.title)
                        .imageScale(.large)
                })
                Button(action: {
                    let increase = self.audioPlayer.currentTime + 15
                    if increase < self.audioPlayer.duration {
                        self.audioPlayer.currentTime = increase
                    } else {
                        self.audioPlayer.currentTime = duration
                    }
                },label:{
                    Image(systemName: "goforward.15")
                        .font(.title)
                        .imageScale(.medium)
                })
                Spacer()
            }
            .foregroundColor(.blue)
            .onAppear {
                initializeAudioPlayer(track: "bach.wav")
            }
            HStack {
                Button(action:{
                    if self.audioPlayer.isPlaying {
                        self.audioPlayer.stop()
                    }
                    initializeAudioPlayer(track: "bach.wav")
                    self.audioPlayer.play()
                    playing = true
                },label:{
                    Text("Bach")
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                })
                Button(action:{
                    if self.audioPlayer.isPlaying {
                        self.audioPlayer.stop()
                    }
                    initializeAudioPlayer(track: "chopin_nocturne_op9_no2.mp3")
                    self.audioPlayer.play()
                    playing = true
                },label:{
                    Text("Chopin")
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                })
                Button(action:{
                    if self.audioPlayer.isPlaying {
                        self.audioPlayer.stop()
                    }
                    initializeAudioPlayer(track: "interstellar.mp3")
                    self.audioPlayer.play()
                    playing = true
                },label:{
                    Text("Intersetllar")
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                })
            }
            HStack {
                Button(action:{
                    if self.audioPlayer.isPlaying {
                        self.audioPlayer.stop()
                    }
                    initializeAudioPlayer(track: "morning_meditation.mp3")
                    self.audioPlayer.play()
                    playing = true
                },label:{
                    Text("Morning Meditation")
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                })
                
            }
            Text("*Siho Sung, Maliq Sims, & Jeet Shah")
                .foregroundColor(Color.blue)
                .bold()
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .minimumScaleFactor(0.75)
                .padding()
        }
    }
    
    func initializeAudioPlayer(track: String) {
        
        /*let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("error.")
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {

        }
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
        } catch _ {

        }*/
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [ .pad ]
        
        //let path = Bundle.main.path(forResource: track, ofType: "wav")!
        let path = Bundle.main.path(forResource: track, ofType: "")!
        self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.numberOfLoops = 100
        formattedDuration = formatter.string(from: TimeInterval(self.audioPlayer.duration))!
        duration = self.audioPlayer.duration
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if !audioPlayer.isPlaying {
                playing = false
            }
            progress = CGFloat(audioPlayer.currentTime / audioPlayer.duration)
            formattedProgress = formatter.string(from: TimeInterval(self.audioPlayer.currentTime))!
        }
        
    }
}

struct SoundView_Previews: PreviewProvider {
    static var previews: some View {
        SoundView()
    }
}
