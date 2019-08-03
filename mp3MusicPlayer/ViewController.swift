//
//  ViewController.swift
//  mp3MusicPlayer
//
//  Created by Meheboob MacBook on 8/3/19.
//  Copyright © 2019 Impeedcraft. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var hideAndShowImage: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var prevOutlet: UIButton!
    
    @IBOutlet weak var forwardOutlet: UIButton!
    
    @IBOutlet weak var playPauseOutlet: UIButton!
    
    @IBOutlet weak var songSlider: UISlider!
    
    @IBOutlet weak var startTime: UILabel!
    
    @IBOutlet weak var endTime: UILabel!
    
    let imageArray = ["breakup song.jpg","dear Zindagi.jpg","jolly LLB2.jpg","kabil.jpg","kaun-tujhe.jpg"]
    let songArray = ["hum_tum_ko","kaise_mujhe_tum","kudiyode_nanna_weaknessu","teri_chunariya_dil"]
    
    var index = 0
    
    
    
    var audioPlayer = AVAudioPlayer()
    
    var isPlaying = true
    
    var timer  = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.rotateImageView()
        self.hideAndShowImage.isHidden = true
        
        self.hideAndShowImage.layer.cornerRadius = self.hideAndShowImage.frame.size.width / 2
        self.hideAndShowImage.clipsToBounds = true
        
        self.songImage.layer.cornerRadius = self.songImage.frame.size.width / 2
        self.songImage.clipsToBounds = true
        
      
        self.playPauseOutlet.setBackgroundImage(UIImage.init(named: "pause-button"), for: .normal)
        
        self.songSlider.value = 0
        self.startTime.text = "0.0"
        self.endTime.text = "0.0"
        
        
        
        
        UIView.animate(withDuration: 12.0, delay: 1, options: ([.curveLinear, .repeat]), animations: {() -> Void in
            self.songNameLabel.center = CGPoint(x: 0 - self.songNameLabel.bounds.size.width / 2, y: self.songNameLabel.center.y)
        }, completion:  { _ in })
        
         timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)


        self.playAudio()
        self.songSlider.minimumValue = 0.0;
        self.songSlider.maximumValue = Float(audioPlayer.duration);
    }
    
    
    @IBAction func volumeChanged(_ sender: UISlider) {
        
        self.audioPlayer.volume = sender.value
    }
    
    @IBAction func prevAudio(_ sender: Any) {
        
        index = index - 1
        
        if index < 0 {
            index = songArray.count - 1
        }
        self.playAudio()
        
    }
    
    @IBAction func forwardAudio(_ sender: Any) {
        
        index = index + 1
        if index == songArray.count {
            index = 0
        }
        self.playAudio()
    }
    
    @IBAction func playAudio(_ sender: Any) {
        
        if isPlaying == false {
           
            audioPlayer.play()
            isPlaying = true
            songImage.isHidden = false
            hideAndShowImage.isHidden = true
            
            playPauseOutlet.setBackgroundImage(UIImage.init(named: "pause-button"), for: .normal)
        } else {
            audioPlayer.pause()
            isPlaying = false
            playPauseOutlet.setBackgroundImage(UIImage.init(named: "play-button"), for: .normal)
           
            
            songImage.isHidden = true
            hideAndShowImage.isHidden = false
            hideAndShowImage.image = UIImage(named: imageArray[index])
            songNameLabel.text = songArray[index]
        }

        
        
    }
    
    @IBAction func songSlider(_ sender: UISlider) {
        
        audioPlayer.currentTime = TimeInterval(sender.value);
        
        
    }
    
    
    func playAudio()  {
        
        
        let path = Bundle.main.path(forResource: "\(songArray[index])", ofType: "mp3")
        
    
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path ?? ""))
        } catch {
            
        }

        self.songImage.image = UIImage.init(named: imageArray[index])
        self.songNameLabel.text = songArray[index]
        self.hideAndShowImage.image = UIImage.init(named: imageArray[index])
        
        
        audioPlayer.play()
        isPlaying = false
        
    }
    
    func rotateImageView() {
        UIView.animate(withDuration: 4.0, delay: 0, options: .curveLinear, animations: {
            self.songImage.transform = self.songImage.transform.rotated(by: CGFloat(M_PI_2))
        }) { finished in
            if finished {
                self.rotateImageView()
            }
        }
    }
    
    
    
    
    @objc func updateTime() {
        let currentTime = Int(audioPlayer.currentTime)
        let minutes = currentTime/60
        let seconds = currentTime - minutes * 60
        
        startTime.text = String(format: "%02d:%02d", minutes,seconds) as String
        
        
        let currentTimeS = Int(audioPlayer.duration-audioPlayer.currentTime)
        let minutesS = currentTimeS/60
        let secondsS = currentTimeS - minutesS * 60
        
        endTime.text = String(format: "-%02d:%02d", minutesS,secondsS) as String
        
        self.songSlider.setValue(Float(audioPlayer.currentTime), animated: true)
        
        
    }
    
   
    
    
}


