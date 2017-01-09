# AFNRequest

/**
 *  GET请求
 */
- (void)Get:(NSString *)URLString parameters:(id)parameters success:(Success)success failure:(Failure)failure;

/**
 *  POST请求
 */
- (void)Post:(NSString *)URLString parameters:(id)parameters success:(Success)success failure:(Failure)failure;
