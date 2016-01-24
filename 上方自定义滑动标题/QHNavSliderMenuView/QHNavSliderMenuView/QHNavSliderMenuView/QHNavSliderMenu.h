//
//  SliderTopNavView.h
//  SliderView
//
//  Created by imqiuhang on 15/3/28.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#import "QHHead.h"

typedef NS_ENUM(NSInteger, QHNavSliderMenuType) {
    QHNavSliderMenuTypeTitleOnly = 0,
    QHNavSliderMenuTypeTitleAndImage
};

@protocol QHNavSliderMenuDelegate;

@class QHNavSliderMenuStyleModel;

@interface QHNavSliderMenu : UIView<UIScrollViewDelegate>
{
@protected
    QHNavSliderMenuStyleModel *styleModel;
    
    __weak id<QHNavSliderMenuDelegate>sliderDelegate;
}

/*init*/
- (instancetype)initWithFrame:(CGRect)frame
                andStyleModel:(QHNavSliderMenuStyleModel *)styleModel
                  andDelegate:(id<QHNavSliderMenuDelegate>)delegate
                     showType:(QHNavSliderMenuType)type;

/*!
 *  @author imqiuhang, 15-08-12
 *
 *  @brief  如果外部的视图是可以滑动的  那么滑动了以后 调用这个方法来更改被选中的btn
 *
 *  @param row      第几个 是从0开始的
 *  @param delegate 是否回调 在外部调用的话一般都是no 如果想再次调起delegate则设置为yes 那么就会调起navSliderMenuDidSelectAtRow:(NSInteger)row;
 */
- (void)selectAtRow:(NSInteger)row andDelegate:(BOOL)delegate;

@property (nonatomic,readonly)NSInteger currentSelectIndex;

@end

@interface QHNavSliderMenuStyleModel : NSObject


/*menu的标题数组,必传*/
@property (nonatomic,strong) NSArray *menuTitles;

//>>>>>>>>>QHNavSliderMenuType为QHNavSliderMenuTypeTitleAndImage类型需要设置的4个属性
/*未选中显示的图片数组*/
@property (nonatomic,strong) NSArray *menuImagesNormal;
/*选中时显示的图片数组*/
@property (nonatomic,strong) NSArray *menuImagesSelect;
/*未选中时候按钮的颜色*/
@property (nonatomic,strong) UIColor *sliderMenuBtnBgColorForSelect;
/*选中时候按钮的图片*/
@property (nonatomic,strong) UIColor *sliderMenuBtnBgColorForNormal;
//<<<<<<<<<<<<<<<<<<<<<<<<



/*选中时候文字的颜色*/
@property (nonatomic,strong) UIColor *sliderMenuTextColorForSelect;
/*未选中时候文字的颜色*/
@property (nonatomic,strong) UIColor *sliderMenuTextColorForNormal;

@property (nonatomic,strong)UIColor *lineColor;
@property (nonatomic)float lineHeight;
/*文字的font 默认是system size10*/
@property (nonatomic,strong) UIFont  *titleLableFont;

/*按钮之间的间距 默认是0*/
@property (nonatomic       ) float   menuHorizontalSpacing;
/*按钮的宽度   默认是屏幕宽度/4 */
@property (nonatomic       ) float   menuWidth;

/*适应屏幕，居中显示，只有当一个屏幕能全部显示的下的时候才有效*/
@property (nonatomic)BOOL sizeToFitScreenWidth;

//居中显示
@property (nonatomic)BOOL sizeInMiddle;

//是否根据文本的长短自动调整线条的长度
@property (nonatomic)BOOL autoSuitLineViewWithdForBtnTitle;



@property (nonatomic)BOOL donotScrollTapViewWhileScroll;

@property (nonatomic)BOOL hideViewBottomLineView;


+ (instancetype)menuStyleModelForHome;


@end


@protocol QHNavSliderMenuDelegate <NSObject>

@required

///点击了某个按钮
- (void)navSliderMenuDidSelectAtRow:(NSInteger)row;

@optional
///重复点击了某个按钮
- (void)navSliderMenuDidReSelectAtRow:(NSInteger)row;
- (void)navScrollViewDidScroll:(float)offsetX;



@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com