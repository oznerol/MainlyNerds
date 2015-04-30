//
//  ArticleCollectionViewCell.h
//  MainlyNerds
//
//  Created by Lorenzo on 4/15/15.
//  Copyright (c) 2015 Smugbit Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChildViewControllerDelegate <NSObject>

- (void)more;

@end

@interface ArticleCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *articleThumb;
@property (weak, nonatomic) IBOutlet UILabel *articleText;
@property (weak, nonatomic) IBOutlet UILabel *articleAuthor;
@property (weak, nonatomic) IBOutlet UIButton *loadMoreButton;
@property (weak, nonatomic) IBOutlet UIView *shadowBG;


@property (nonatomic) CGRect origRect;

@property (nonatomic, weak) id<ChildViewControllerDelegate> delegate;


-(IBAction)loadMore:(id)sender;
@end

