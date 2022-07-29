//
//  ViewController.swift
//  HozScrollTest2
//
//  Created by Hyeon Jong Kim on 2022/07/29.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var prevImageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var nextImageView: UIImageView!
    
    private var before_x: CGFloat = 0
    
    private var images = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
                          "11", "12", "13", "14", "15", "16", "17", "18"]
    
    private var prevIndex: Int {
        var index = currentIndex - 1
        if index < 0 {
            index += images.count
        }
        return index
    }
    
    private var currentIndex: Int = 0
    
    private var nextIndex: Int {
        (currentIndex + 1) % images.count
    }
    
    private var currentImage: UIImage? {
        UIImage(named: self.images[self.currentIndex])
    }
    
    private var prevImage: UIImage? {
        UIImage(named: self.images[self.prevIndex])
    }

    private var nextImage: UIImage? {
        UIImage(named: self.images[self.nextIndex])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mainImageView.isUserInteractionEnabled = true
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPanGesture(_:)))
        mainImageView.addGestureRecognizer(recognizer)
        
        prevImageView.layer.zPosition = 10
        nextImageView.layer.zPosition = 10
        
        prevImageView.image = self.prevImage
        mainImageView.image = self.currentImage
        nextImageView.image = self.nextImage
    }

    @objc func onPanGesture(_ recognizer: UIGestureRecognizer) {
        
        let pt = recognizer.location(in: self.view)
        
        switch recognizer.state {
        case .began:
            before_x = pt.x
            
        case .changed:
            let diff = pt.x - before_x
            mainImageView.transform = .init(translationX: diff*0.15, y: 0)
            
            if diff > 0 {
                prevImageView.transform = .init(translationX: diff, y: 0)
                nextImageView.transform = .identity
            }
            else {
                prevImageView.transform = .identity
                nextImageView.transform = .init(translationX: diff, y: 0)
            }
            
        case .ended:
            let w = self.mainImageView.frame.width
            let diff = pt.x - before_x
            
            if abs(diff) > w/2 {
                UIView.animate(withDuration: 0.3, delay: 0, options: []) {
                    self.mainImageView.transform = .init(translationX: w*0.15*(diff > 0 ? 1 : -1), y: 0)
                    
                    if diff > 0 {
                        self.prevImageView.transform = .init(translationX: w, y: 0)
                    }
                    else {
                        self.nextImageView.transform = .init(translationX: -w, y: 0)
                    }

                } completion: { _ in
                    if diff > 0 {
                        self.currentIndex = self.prevIndex
                    }
                    else {
                        self.currentIndex = self.nextIndex
                    }

                    self.prevImageView.image = self.prevImage
                    self.mainImageView.image = self.currentImage
                    self.nextImageView.image = self.nextImage

                    self.mainImageView.transform = .identity
                    self.prevImageView.transform = .identity
                    self.nextImageView.transform = .identity
                }
            }
            else {
                UIView.animate(withDuration: 0.3, delay: 0, options: []) {
                    self.mainImageView.transform = .identity
                    self.prevImageView.transform = .identity
                    self.nextImageView.transform = .identity
                    
                } completion: { _ in
                }
            }

        default:
            break
        }
    }

}

