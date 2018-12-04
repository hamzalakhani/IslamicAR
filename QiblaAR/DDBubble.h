//
//  DDBubble.h
//  Coach Marks
//
//  Created by Darin Doria on 02/17/2014.
//  Copyright (c) 2014 Darin Doria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DDBubble : UIView

typedef enum {
    CRArrowPositionTop,
    CRArrowPositionBottom,
    CRArrowPositionRight,
    CRArrowPositionLeft
} CRArrowPosition;

@property (nonatomic, assign)   CRArrowPosition arrowPosition;
@property (nonatomic, strong)   UIView *attachedView;
@property (nonatomic, strong)   NSString *title;
@property (nonatomic, strong)   NSString *bubbleText;
@property (nonatomic, strong)   UIColor *color;
@property (nonatomic)           CGRect attachedFrame;
@property (nonatomic)           BOOL  bouncing;
@property (nonatomic)           BOOL animationShouldStop;
@property (nonatomic)           UIFont *font;

-(id)initWithAttachedView:(UIView*)view title:(NSString*)title description:(NSString*)description arrowPosition:(CRArrowPosition)arrowPosition andColor:(UIColor*)color;
-(id)initWithFrame:(CGRect)frame title:(NSString*)title description:(NSString*)description arrowPosition:(CRArrowPosition)arrowPosition andColor:(UIColor*)color;
-(id)initWithFrame:(CGRect)frame title:(NSString*)title description:(NSString*)description arrowPosition:(CRArrowPosition)arrowPosition color:(UIColor*)color andFont:(UIFont *)font;

-(void)animate;
@end
