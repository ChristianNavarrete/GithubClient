//
//  CustomSegue.swift
//  GithubClient
//
//  Created by HoodsDream on 11/15/15.
//  Copyright © 2015 HoodsDream. All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue {

    
    override func perform() {
        
        
        let sourceVC = self.sourceViewController
        let destVC = self.destinationViewController
        
        sourceVC.view.addSubview(destVC.view)
        destinationViewController.view.transform = CGAffineTransformMakeScale(0.05, 0.05)
        
        UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.3, options: .CurveEaseOut, animations: { () -> Void in
            
            
            destVC.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
            
            
            }) { (finished) -> Void in
                
                
                destVC.view.removeFromSuperview()
                
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.001 * Double(NSEC_PER_SEC)))
                
                dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
                    
                    
                    sourceVC.presentViewController(destVC, animated: false, completion: nil)
                    
                    
                })
                
                
                
        }
        
        
    }
    
    
    
    
    
    
    

}
