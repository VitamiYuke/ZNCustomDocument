//
//  InterfaceDomainConfigure.h
//  ZNDocument
//
//  Created by 张楠 on 17/3/2.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#ifndef InterfaceDomainConfigure_h
#define InterfaceDomainConfigure_h






//股票的域名
#define StockDomainName(api,category) ([NSString stringWithFormat:@"https://quote.5igupiao.com/%@/%@.php",api,category])

#define RelatedMarket(begin,api,category) [NSString stringWithFormat:@"http://%@.inv.org.cn/%@/%@.php",begin,api,category]





#endif /* InterfaceDomainConfigure_h */
