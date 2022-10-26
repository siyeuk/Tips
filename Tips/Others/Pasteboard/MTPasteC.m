//
//  MTPasteC.m
//  MT_Tips
//
//  Created by lss on 2022/10/17.
//

#import "MTPasteC.h"

@interface MTPasteC ()

@end

@implementation MTPasteC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建数据剪切板
    UIPasteboard *systemBoard = [UIPasteboard generalPasteboard];
    // 将文本写入剪切板
    systemBoard.string = @"OK";
    // 给剪切板加入一条标记性的数据,只是为了检测剪切板的数据是否来自当前应用
    NSDictionary<NSString *, id> *item = @{@"PASTEBOARD_MARK": @"ok"};
    [systemBoard addItems:@[item]];
    
    
    // Do any additional setup after loading the view.
}
// hasMark方法是用来判断剪切板是否有我们写入的标志数据，返回YES表示此条剪切板数据是我们自己写入的，则不需要处理。否则就是别人的数据，需要处理的。
- (BOOL)hasMark {
    //创建系统剪切板
     UIPasteboard *systemBoard = [UIPasteboard generalPasteboard];
     if(!systemBoard.numberOfItems) {
         return YES;
     }
     
     NSArray<NSDictionary<NSString *, id> *> *items = systemBoard.items;
     long count = systemBoard.numberOfItems;
     for(int i=0; i < count; i++){
         NSDictionary<NSString *, id> *item = [items objectAtIndex:i];
         if([[item allKeys] containsObject:@"PASTEBOARD_MARK"]){
             return YES;
         }
     }
    return NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
