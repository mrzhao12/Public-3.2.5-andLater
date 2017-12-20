
//  QQtagView
//
//  Created by ZhangQun on 2017/4/8.
//  Copyright © 2017年 ZhangQun. All rights reserved.
//

#import <UIKit/UIKit.h>
//选中的颜色
#define SelectColor  YYSRGBColor(40, 150, 50, 1)
//显示的颜色
#define ShowColor  [UIColor groupTableViewBackgroundColor]

typedef NS_ENUM(NSInteger,QQTagStyle){
    QQTagStyleSlect = 0,// 不可编辑的选中状态
    QQTagStyleNone = 1,//不可编辑的无状态
    QQTagStyleEditNone = 2,//可编辑的无状态
    QQTagStyleEditSlect = 3,// 可编辑的选中状态

};
@class QQTagItem;


@protocol QQTagItemDelegate <NSObject>

- (void)QQTagItem:(QQTagItem *)QQTagItem;

@end

@interface QQTagItem :  UILabel<UITextFieldDelegate>

@property (nonatomic,assign) QQTagStyle Style;
@property (nonatomic,assign) id<QQTagItemDelegate> mydelagete;
@property(nonatomic) UIEdgeInsets padding;
@property (nonatomic,strong) UIColor * EditShowColor;

- (instancetype)initWith:(QQTagStyle)tagstyle;
@end
