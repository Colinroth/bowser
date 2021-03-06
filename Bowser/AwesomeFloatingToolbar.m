//
//  AwesomeFloatingToolbar.m
//  Bowser
//
//  Created by Colin M. Roth on 4/18/15.
//  Copyright (c) 2015 iamcolinroth. All rights reserved.
//

#import "AwesomeFloatingToolbar.h"

@interface AwesomeFloatingToolbar ()

@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, weak) UILabel *currentLabel;

@end

@implementation AwesomeFloatingToolbar

-(instancetype) initWithFourTitles:(NSArray *)titles {
    self = [super init];
    
    if (self) {
        
        self.currentTitles = titles;
        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        
        NSMutableArray *labelArray = [[NSMutableArray alloc] init];
        
        for (NSString *currentTitle in self.currentTitles) {
            UILabel *label = [[UILabel alloc] init];
            label.userInteractionEnabled = NO;
            label.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle];
            NSString *titleForThisLabel = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisLabel = [self.colors objectAtIndex:currentTitleIndex];
            
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];
            label.text = titleForThisLabel;
            label.backgroundColor = colorForThisLabel;
            label.textColor = [UIColor whiteColor];
            
            [labelArray addObject:label];
        }
        
        self.labels = labelArray;
        
        for (UILabel *thisLabel in self.labels) {
            [self addSubview:thisLabel];
        }
        
    }
    
    return self;
}

-(void) layoutSubviews {

    for (UILabel *thisLabel in self.labels) {
        NSUInteger currentLabelIndex = [self.labels indexOfObject:thisLabel];
        
        CGFloat labelHeight = CGRectGetHeight(self.bounds) /2;
        CGFloat labelWidth =CGRectGetWidth(self.bounds) /2;
        CGFloat labelX = 0;
        CGFloat labelY = 0;
        
        if (currentLabelIndex < 2) {
            
            labelY = 0;
            
        } else {
            labelY = CGRectGetHeight(self.bounds) /2;
        }
        
        if (currentLabelIndex % 2 == 0) {
            labelX = 0;
        } else {
            labelX = CGRectGetWidth(self.bounds) /2;
        }
        thisLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
    }
}

#pragma mark - Touch Handling

-(UILabel *) labelFromtouches:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *subview = [self hitTest:location withEvent:event];
    return (UILabel *)subview;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UILabel *label = [self labelFromtouches:touches withEvent:event];
    
    self.currentLabel = label;
    self.currentLabel.alpha = 0.5;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UILabel *label = [self labelFromtouches:touches withEvent:event];
    
    if (self.currentLabel != label) {
        
        self.currentLabel.alpha = 1;
    } else {
        self.currentLabel.alpha = 0.5;
    }

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UILabel *label = [self labelFromtouches:touches withEvent:event];
    
    if (self.currentLabel == label) {
        NSLog(@"label tapped: %@", self.currentLabel.text);
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
            [self.delegate floatingToolbar:self didSelectButtonWithTitle:self.currentLabel.text];
        }
    }
    
    self.currentLabel.alpha = 1;
    self.currentLabel = nil;

}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.currentLabel.alpha = 1;
    self.currentLabel = nil;
}

#pragma mark - Button Enabling

-(void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title {
    NSUInteger index = [self.currentTitles indexOfObject:title];
    
    if (index != NSNotFound) {
        UILabel *label = [self.labels objectAtIndex:index];
        label.userInteractionEnabled = enabled;
        label.alpha = enabled ? 1.0 : 0.25;
    
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
