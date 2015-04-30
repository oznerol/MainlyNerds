//
//  ViewController.h
//  MainlyNerds
//
//  Created by Lorenzo on 4/13/15.
//  Copyright (c) 2015 Smugbit Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "ArticleObject.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <CHTCollectionViewWaterfallLayout.h>
#import "ArticleView.h"
#import <DateTools.h>
#import "ArticleCollectionViewCell.h"
#import <MWFeedParser/NSString+HTML.h>
#import "CategoryObject.h"
#import "CategoryButton.h"

#define RANDFLOAT(smallNumber, bigNumber) ((((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * (bigNumber - smallNumber)) + smallNumber)

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, ChildViewControllerDelegate, ArticleViewDelegate, UIScrollViewDelegate>
{
    NSMutableArray *articleArray;
    NSMutableArray *categoryArray;
    int currentPage;
    int currentArticleIndex;
    NSString *loadURL;
    
    int maxArticles;
    int maxPages;
    
    int currentID;
}

@property (nonatomic, strong) NSMutableDictionary *menuDict;

@property (strong, nonatomic) IBOutlet UIScrollView *menuScrollView;
@property (strong, nonatomic) IBOutlet UIView *menuView;

@property (strong, nonatomic) IBOutlet UICollectionView *articleCollectionView;
@property (strong, nonatomic) IBOutlet UIView *grayView;

//@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSMutableArray *cellSizes;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) UIImageView *feedItemImageView;
@property (nonatomic, strong) ArticleObject *feedItem;
@property (nonatomic, strong) ArticleView *myArticleView;
@property (nonatomic, strong) ArticleCollectionViewCell *myArticleCell;
@property (nonatomic, strong) UICollectionView *collection;



@property (nonatomic, strong) IBOutlet UIBarButtonItem *closeButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *menuButton;
@property (nonatomic, strong) IBOutlet UINavigationItem *navItem;

@end
