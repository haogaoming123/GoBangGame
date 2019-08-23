//
//  Board.m
//  Gomoku
//
//  Created by Changchang on 27/5/17.
//  Copyright © 2017 University of Melbourne. All rights reserved.
//

#import "GGBoardView.h"

@interface GGBoardView () {
    CGFloat margin;
    CGFloat interval;
    UIImageView *indicatorView;
    NSMutableArray *imageViews;
}
//@property (strong, nonatomic) UIImageView *blackPieceImageView;
//@property (strong, nonatomic) UIImageView *whitePieceImageView;

@end

@implementation GGBoardView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer: tap];
    
    indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"indicator"]];
    imageViews = [NSMutableArray array];
    
    return self;
}

- (void)reset {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [imageViews removeAllObjects];
}

- (void)handleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    CGPoint location = [tapGestureRecognizer locationInView:self];
    
    GGPoint point = [self findPointWithLocation:location];
    
    [self.delegate boardView:self didTapOnPoint:point];
}

- (GGPoint)findPointWithLocation:(CGPoint)location {
    int row = (int)((location.y - margin) / interval);
    double modY = (location.y - margin) / interval - row;
    if(modY > 0.5 && row < 14) {
        row++;
    }
    
    int column = (int)((location.x - margin) / interval);
    double modX = (location.x - margin) / interval - column;
    if(modX > 0.5 && column < 14) {
        column++;
    }
    GGPoint point;
    point.i = row;
    point.j = column;
    NSLog(@"%d, %d", row, column);
    return point;
}

- (void)insertPieceAtPoint:(GGPoint)point playerType:(GGPlayerType)playerType{
    
    NSString *imageName;
    if (playerType == GGPlayerTypeBlack) {
        imageName = @"piece_black";
//        self.blackPieceImageView = pieceImage;
    } else {
        imageName = @"piece_white";
//        self.whitePieceImageView = pieceImage;
    }
    
    CGFloat imageSize = interval;
    
    CGFloat originX = margin + point.j * interval - imageSize / 2;
    CGFloat originY = margin + point.i * interval - imageSize / 2;
//    UIImageView *pieceImage = [[UIImageView alloc] init];
//    pieceImage.image = [UIImage imageNamed:imageName];
    UIImageView *pieceImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    CGRect rect = CGRectMake(originX, originY, imageSize, imageSize);
    pieceImage.frame = rect;
    [imageViews addObject:pieceImage];
    [self addSubview:pieceImage];
    
    indicatorView.frame = rect;
    if (indicatorView.superview != self) {
        [self addSubview:indicatorView];
    }
    
}

//- (void)removeImageForMove:(GGMove *)move {
//    if (move.playerType == GGPlayerTypeBlack) {
//        [_blackPieceImageView removeFromSuperview];
//    } else {
//        [_whitePieceImageView removeFromSuperview];
//    }
//}

- (void)removeImageWithCount:(int)count {
    for (int i = 0; i < count; i++) {
        UIImageView *imageView = [imageViews lastObject];
        [imageView removeFromSuperview];
        imageView = nil;
        [imageViews removeLastObject];
    }
    UIImageView *imageView = [imageViews lastObject];
    if (imageView != nil) {
        indicatorView.frame = imageView.frame;
    } else {
        [indicatorView removeFromSuperview];
    }
    
}


- (void)drawRect:(CGRect)rect {
    UIImage *background = [UIImage imageNamed:@"board2"];
    [background drawInRect:rect];
    
    // Draw border
    CGRect borderRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.height, rect.size.width);
    UIBezierPath *border = [UIBezierPath bezierPathWithRoundedRect:borderRect cornerRadius:0];
    border.lineWidth = 8;
    [[UIColor blackColor] setStroke];
    [border stroke];
    
    margin = 15;
    interval =(self.bounds.size.width - margin * 2) / 14;

    
    CGFloat borderLineWidth = 2;
    CGFloat insideLineWidth = 1;
    
    // Draw lines on the board
    for (int i = 0; i < 15; i++) {
        UIBezierPath *horizontalLine = [[UIBezierPath alloc] init];
        UIBezierPath *verticalLine = [[UIBezierPath alloc] init];
        
        if (i == 0 || i == 14) {
            [horizontalLine moveToPoint:CGPointMake(margin - 1, interval * i + margin)];
            [verticalLine moveToPoint:CGPointMake(interval * i + margin, margin)];
            
            [horizontalLine addLineToPoint:CGPointMake(margin + interval * 14 + 1, interval * i + margin)];
            [verticalLine addLineToPoint:CGPointMake(interval * i + margin, margin + interval * 14)];
            
            horizontalLine.lineWidth = borderLineWidth;
            verticalLine.lineWidth  = borderLineWidth;
        } else {
            [horizontalLine moveToPoint:CGPointMake(margin, interval * i + margin)];
            [verticalLine moveToPoint:CGPointMake(interval * i + margin, margin)];
            
            [horizontalLine addLineToPoint:CGPointMake(margin + interval * 14, interval * i + margin)];
            [verticalLine addLineToPoint:CGPointMake(interval * i + margin, margin + interval * 14)];
            
            horizontalLine.lineWidth = insideLineWidth;
            verticalLine.lineWidth  = insideLineWidth;
        }
        
        [[UIColor blackColor] setStroke];
        
        [horizontalLine stroke];
        [verticalLine stroke];
    }
    
    // Draw 5 dots on the board
    CGFloat dotRadius = 3;
    int dotList[5][2] = {{3, 3}, {3, 11}, {7, 7}, {11, 3}, {11, 11}};
    
    for (int i = 0; i < 5; i++) {
        CGFloat centerX = margin + dotList[i][0] * interval;
        CGFloat centerY = margin + dotList[i][1] * interval;
        CGRect rect = CGRectMake(centerX - dotRadius, centerY - dotRadius, dotRadius * 2, dotRadius * 2);
        UIBezierPath *dot = [UIBezierPath bezierPathWithOvalInRect:rect];
        [[UIColor blackColor] setFill];
        [dot fill];
    }
}
@end
