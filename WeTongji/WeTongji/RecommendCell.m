//
//  RecommendCell.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-27.
//
//

#import "RecommendCell.h"
#import "DetailImageViewController.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#define kOffset 6
#define kMaxWidth 167
#define kIconX 271

@interface RecommendCell()

@end

@implementation RecommendCell
@synthesize infoTitle = _infoTitle;
@synthesize source = _source;
@synthesize icon = _icon;
@synthesize count = _count;
@synthesize preview = _preview;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setInformation:(Information *)information
{
    self.infoTitle.text = information.title;
    [self.infoTitle sizeToFit];
    
    if (self.infoTitle.frame.size.width > kMaxWidth) {
        CGRect oldFrame = self.infoTitle.frame;
        oldFrame.size.width = kMaxWidth;
        self.infoTitle.frame = oldFrame;
        
        CGRect iconFrame = self.icon.frame;
        iconFrame.origin.x = kIconX - 2;
        self.icon.frame = iconFrame;
    } else {
        CGRect oldFrame = self.icon.frame;
        CGRect titleFrame = self.infoTitle.frame;
        float newX = titleFrame.origin.x + kOffset + titleFrame.size.width;
        oldFrame.origin.x = newX;
        self.icon.frame = oldFrame;
    }
    [self.icon setHidden:([information.ticketService isEqualToString:[NSString stringWithFormat:@"%@",[NSNull null]]] ? YES : NO)];
    self.source.text = information.summary;
    self.count.text = [information.read stringValue];
    [self.preview setImageWithURL:[NSURL URLWithString: information.image]];
    _information = information;
}
- (IBAction)imageClicked:(id)sender
{
    [DetailImageViewController showDetailImageWithURL:self.information.image];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
