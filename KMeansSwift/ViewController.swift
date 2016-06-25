//
//  ViewController.swift
//  KMeansSwift
//
//  Created by sdq on 15/12/22.
//  Copyright © 2015年 sdq. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    @IBOutlet weak var spaceView: UIView!
    @IBOutlet weak var clusterButton1: UIButton!
    @IBOutlet weak var clusterButton2: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var centroidsSwitch: UISwitch!
    
    //var showCentroids:Bool
    
    
    let KMeans = KMeansSwift.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapSpaceView:")
        spaceView.addGestureRecognizer(tapGesture)
        spaceView.userInteractionEnabled = true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Action
    @IBAction func start3Clustering(sender: UIButton) {
        if KMeans.vectors.count < 3 {
            return
        }
        setButtonEnable(false)
        KMeans.clusteringNumber = 3
        KMeans.clustering(500) { [unowned self] (success, centroids, clusters) -> () in
            if success {
                for point:UIView in self.spaceView.subviews {
                    point.removeFromSuperview()
                }
                for index in 0...2 {
                    for vector in clusters[index] {
                        let pointFrame = CGRectMake(CGFloat(vector[0]) - 10, CGFloat(vector[1]) - 10, 20.0, 20.0)
                        let point = UIImageView(frame: pointFrame)
                        if index == 0 {
                            point.image = UIImage(named: "red")
                        } else if index == 1 {
                            point.image = UIImage(named: "yellow")
                        } else {
                            point.image = UIImage(named: "green")
                        }
                        self.spaceView.addSubview(point)
                    }
                }
                
                if(self.centroidsSwitch.on){
                    self.visualizeCentroids(centroids);
                }


            }
            self.setButtonEnable(true)
        }
    }
    
    @IBAction func start2Clustering(sender: UIButton) {
        if KMeans.vectors.count < 2 {
            return
        }
        setButtonEnable(false)
        KMeans.clusteringNumber = 2
        KMeans.clustering(500) { [unowned self] (success, centroids, clusters) -> () in
            if success {
                
                
                
                for point:UIView in self.spaceView.subviews {
                    point.removeFromSuperview()
                }
                for index in 0...1 {
                    for vector in clusters[index] {
                        let pointFrame = CGRectMake(CGFloat(vector[0]) - 10, CGFloat(vector[1]) - 10, 20.0, 20.0)
                        let point = UIImageView(frame: pointFrame)
                        if index == 0 {
                            point.image = UIImage(named: "red")
                        } else {
                            point.image = UIImage(named: "green")
                        }
                        self.spaceView.addSubview(point)
                    }
                }
                
                if(self.centroidsSwitch.on){
                    self.visualizeCentroids(centroids);
                }

                
            }
            self.setButtonEnable(true)
        }
    }
    
    @IBAction func clickGithubItem(sender: UIBarButtonItem) {
        let svc = SFSafariViewController(URL: NSURL(string: "https://github.com/sdq/KMeansSwift")!)
        svc.delegate = self
        self.presentViewController(svc, animated: true, completion: nil)
    }
    
    @IBAction func clickWikiItem(sender: UIBarButtonItem) {
        let svc = SFSafariViewController(URL: NSURL(string: "https://en.wikipedia.org/wiki/K-means_clustering")!)
        svc.delegate = self
        self.presentViewController(svc, animated: true, completion: nil)
    }
    
    @IBAction func clearAll(sender: UIButton) {
        setButtonEnable(false)
        KMeans.reset()
        for point:UIView in self.spaceView.subviews {
            point.removeFromSuperview()
        }
        
        generateRandomPoints(100)
        
        setButtonEnable(true)
    }
    
    func tapSpaceView(recognizer:UITapGestureRecognizer) {
        let location = recognizer.locationInView(spaceView)
        let pointFrame = CGRectMake(location.x - 10, location.y - 10, 20, 20)
        let grayPoint = UIImageView(frame: pointFrame)
        grayPoint.image = UIImage(named: "gray")
        spaceView.addSubview(grayPoint)
        KMeans.addVector([Double(location.x), Double(location.y)])
    }
    
    @IBAction func onSwitchChange(sender: UISwitch) {
        //showCentroids = !showCentroids
        if(KMeans.finalCentroids.count >= 2){
            if(sender.on){
                visualizeCentroids(KMeans.finalCentroids)
            }
            else{
                removeCentroids(KMeans.finalCentroids)
            }
        }
    }
    
    private func setButtonEnable(enable:Bool) {
        clusterButton1.enabled = enable
        clusterButton2.enabled = enable
        clearButton.enabled = enable
    }
    
    
    private func visualizeCentroids(centroids:KMVectors){
        for vector in centroids{
            let pointFrameC = CGRectMake(CGFloat(vector[0]) - 10, CGFloat(vector[1]) - 10, 20.0, 20.0)
            let pointC = UIImageView(frame: pointFrameC)
            pointC.image = UIImage(named: "gray")
            self.spaceView.addSubview(pointC)
        }
    }
    
    
    private func removeCentroids(centroids:KMVectors){
        setButtonEnable(false)
        for point:UIView in self.spaceView.subviews {
            for vector in centroids{
                let point2 = CGRectMake(CGFloat(vector[0]) - 10, CGFloat(vector[1]) - 10, 20.0,20.0)
                if(point.frame.contains(point2)){
                    point.removeFromSuperview()
                }
            }

        }
        setButtonEnable(true)
    }
    

    
    private func generateRandomPoints(number:Int){
        setButtonEnable(false)
        
        let maxX:Float = (Float)(self.spaceView.bounds.maxX-10);
        let maxY:Float = (Float)(self.spaceView.bounds.maxY-10);
        
        for _ in 0...100{
            
            let x:CGFloat = CGFloat( (Float(arc4random()) / Float(UINT32_MAX)) * (maxX - 10) + 10)
            let y:CGFloat = CGFloat((Float(arc4random()) / Float(UINT32_MAX))  * (maxY - 10) + 10)
            let pointFrameC = CGRectMake(  x - 10, y - 10, 20.0, 20.0)
            let pointC = UIImageView(frame: pointFrameC)
            pointC.image = UIImage(named: "gray")
            self.spaceView.addSubview(pointC)
            KMeans.addVector([Double(x), Double(y)])
            
        }
        
        setButtonEnable(true)
        
    }
    

}

// MARK: SFSafariViewControllerDelegate

extension ViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

