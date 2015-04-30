//
//  FlipReplaceSegue.m
//  MainlyNerds
//
//  Created by Lorenzo on 4/16/15.
//  Copyright (c) 2015 Smugbit Studios. All rights reserved.
//

#import "FlipReplaceSegue.h"

@implementation FlipReplaceSegue

-(void) perform1
{
    UIViewController *destVC = self.destinationViewController;
    UIViewController *sourceVC = self.sourceViewController;
    [destVC viewWillAppear:YES];
    
    destVC.view.frame = sourceVC.view.frame;
    
    [UIView transitionFromView:sourceVC.view
                        toView:destVC.view
                      duration:0.7
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished)
					{
                        [destVC viewDidAppear:YES];
                        
                        UINavigationController *nav = sourceVC.navigationController;
                        // push the new destVC
                        [nav pushViewController:destVC animated:NO];
                        // manually pop the sourceVC
                        NSMutableArray *newNavVCs = [nav.viewControllers mutableCopy];
                        [newNavVCs removeObject:sourceVC];
                        nav.viewControllers = newNavVCs;
                    }
     ];
}

-(void) perform{
    [[[self sourceViewController] navigationController] pushViewController:[self   destinationViewController] animated:NO];
}


@end
