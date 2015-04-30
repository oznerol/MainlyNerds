//
//  ArticleCollectionViewCell.m
//  MainlyNerds
//
//  Created by Lorenzo on 4/15/15.
//  Copyright (c) 2015 Smugbit Studios. All rights reserved.
//

#import "ArticleCollectionViewCell.h"

@implementation ArticleCollectionViewCell


-(IBAction)loadMore:(id)sender
{
    NSLog(@"Loading more...");
    id<ChildViewControllerDelegate> strongDelegate = self.delegate;
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([strongDelegate respondsToSelector:@selector(more)])
    {
        [strongDelegate more];
    }

}

@end
