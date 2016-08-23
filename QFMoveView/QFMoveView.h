//
//  QFMoveView.h
//  QFMoveView
//
//  Created by QianFan_Ryan on 16/8/23.
//  Copyright © 2016年 QianFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QFMoveView : UIView

@property (nonatomic, assign)NSUInteger perRowCount;//每行个数 default is 4
@property (nonatomic, assign)CGFloat topMargin;//上边距 default is 0
@property (nonatomic, assign)CGFloat leftMargin;//左边距   default is 0
@property (nonatomic, assign)CGFloat bottomMargin;//底边距 default：15
@property (nonatomic, assign)CGFloat rightMargin;//右边距  default is 0
@property (nonatomic, assign)CGFloat horizontalInterval;//水平间距  default is 0
@property (nonatomic, assign)CGFloat verticalInterval;//垂直间距    default is 0
@property (nonatomic, assign)CGFloat widthHeightScale;//高：宽     default is 1:1

- (void)setData:(NSArray *)data;

@end
