# MGRxKitchen运用

## 1. 我有个请求
 1. 前置条件是我从ApiWings中定义了一个请求。比如：

		public protocol WillGetLeaseRooms: MGServiceWingsProvider {
		    func getLeaseRooms() -> Observable<Result<[String : Any], MGAPIError>>
		}
		
		extension WillGetLeaseRooms {
		    public func getLeaseRooms() -> Observable<Result<[String : Any], MGAPIError>> {
		        return observableRequest(LeaseRoomsRequest(), withResponseMapping: contentFetcher)
		    }
		}
2. 在我的ViewModel中需要实现1-2个协议：

		 class SmartHomeViewModel : WillGetLeaseRooms,NeedHandleRequestError,HaveRequestRx
		 {
		 	...
		 }
		 
	> ### HaveRequestRx
	
	> 当你实现了这个协议，你就会获得一个`pureRequest`这样一个方法，他可以将`Observable<Result<[String : Any], MGAPIError>> `这样一个对象转化为简单的：`Observable<[String : Any]>`对象，并且过滤掉所有错误的情况，即无视所有错误，一旦出现请求错误，这后面所有能量都是不会继续传递的哟
	同时协议中需要你强制实现：
	
		var loadingActivity : ActivityIndicator { get set }
	>这样一个东西，这个可以跟踪请求是否正在进行，方便于转圈的调用，后续会介绍怎么用
	
	当然这还有个可选实现的方法`trackLoadMySelf`，如果你在这里返回了true，那loading信号将不会触发咯
	


	> ### NeedHandleRequestError
	
	> 当你实现了这个协议，你会获得一个类似于上面的那个方法，`requestAfterErrorFilterd`，返回值也一样，但是这个方法会帮你处理error，并且协议需要你实现：
	
		var errorProvider : PublishSubject<RxMGError> { get set }
		
	> 这样一个能量传递者，所有出现了错误的时候，这个能量传递者都会收到一个Error能量，你只要订阅他，就能跟踪所有Error啦

3. 所以这时候我们在VM中定义一个能量传递者用来当请求发动机：

		 class SmartHomeViewModel : WillGetLeaseRooms,NeedHandleRequestError,HaveRequestRx
		 {
		 	 var smartRequest = PublishSubject<Void>()
		 }
		 
	那我们可以这样将它变成一个请求：
	
        smartRequest
            .flatMap{ self.requestAfterErrorFilterd(withResultSignal: self.getLeaseRooms()) }
            .mapBricks()
            .bind(to: smartResponse)
            .disposed(by: disposeBag)
    
   > mapBricks 这个方法就是把你的Dic转化为了对象，而你的对象只需要接上HandyJSON协议就行了：
   
   
		   struct SmartModel: HandyJSON {
		    var chooseIdx: Int = 0  //选择的房间索引 从 0 开始
		    var rooms : [SmartRoomModel] = []
		    var smrtDescUrl:String = "" //智能门锁说明h5链接
		    var unrecognized:Bool = false //是否需要确认租约 1：是， 0：否
		}
		
	> 到mapBricks之后，你的请求已经变成了Observable<Element>对象，就可以拿去用啦
	
	
4. VM中推荐有一个Request发起节点，和一个Request结果节点，

		 class SmartHomeViewModel : WillGetLeaseRooms,NeedHandleRequestError,HaveRequestRx
		 {
		 	 var smartRequest = PublishSubject<Void>()
		 	 var smartResponse = PublishSubject <SmartModel>()
		 }
		 
	为了ViewModel对外的耦合度降低，所以我们做了这样的配置，
	所以对于上面的请求，我们就可以这样配置
	
		init()
		{
			     smartRequest
	            .flatMap{ self.requestAfterErrorFilterd(withResultSignal: self.getLeaseRooms()) }
	            .mapBricks()
	            .bind(to: smartResponse)
	            .disposed(by: disposeBag)
		}
	这时候，VC在拿着你的`smartResponse `节点去ViewController中绑定到你的View上了
	
	>其实这时候你的VM已经提供给你两个能量传递者了，一个smartRequest，是希望你传能量给他，他会去发动请求，而另一个是smartResponse，他是会主动发能量给到外部，只需要外部派人去接就行了,因此有了Input和Output的概念，所以我们可以在ViewModel中，这样划分后可以方便大家查询理解：
	
		class SmartHomeViewModel : WillGetLeaseRooms,NeedHandleRequestError,HaveRequestRx
		 {
		 	 //Input
		 	 var smartRequest = PublishSubject<Void>()
		 	 var xxx = PublishSubject<Void>()
		 	 
		 	 //Outputs
		 	 var smartResponse = PublishSubject <SmartModel>()
		 	 var loadingActivity : ActivityIndicator { get set }
		 	 var errorProvider : PublishSubject<RxMGError> = PublishSubject<RxMGError>()
		 	 var xxx = PublishSubject<Void>()
		 }
	
5. 这是个Controller中的场景：


	    override public func viewDidLoad() {
	        super.viewDidLoad()
	        
	        //这就是你的请求loading绑定，isLoadingOnMe会帮你自动弹转圈，自动关闭转圈
	         viewModel.loadingActivity
         			    .asObservable()
          		     .bind(to: view.rx.isLoadingOnMe)
          		    .disposed(by: disposeBag)
	        
	         //点击button后去请求
	        requestBtn.rx.tap
	            .bind(to: viewModel. smartRequest)
	            .addDisposableTo(disposeBag)
	            
	        //这是个进了viewDidLoad后就会请求的场景
	        smartRequest.onNext()
	        
	        //把Response绑定到TableView上
	        smartResponse.bind(to: tableView.rx.items(cellIdentifier: MGRoomSearchCell.reuseIdentifier)) {
                (index, room: MGSearchRoom, cell) in
                let searchCell = cell as! MGRoomSearchCell
                searchCell.room = room
            }
            .disposed(by: disposeBag)
	  	}
	  	
	这里有个TableView的实例：
[首页房源搜索](http://git.mogo.com/NexT/Partner_iOS/blob/develop/MogoPartner/RoomSearchModule/Controllers/MGRoomSearchViewController.swift)
        
## 2. 我想自己搞个能量接受者
1. MGProgressHUD接受系列

        
        viewModel.errorProvider
            .asObserver()
            .bind(to: view.rx.toastErrorOnMe )
            .disposed(by: viewModel.disposeBag)
    这是个最简单的例子，我们把MGProgressHUD封装成了Rx系列，包括上面提到过的isLoading，这样MGProgress将变成一个信号的最终接受者，`view.rx.toastErrorOnMe `可以获取一个error能量，并将它展示到View上
    
2. Deeplink系列（即将推出）

        tableView.rx
            .itemSelected()
            .map { $0.row }
            .bind(to: self.rx.goNavigation)
            .disposed(by: disposeBag)
            
      这样之后，你点击tableview就会自动跳转咯，所以实现：
      
      
	    extension Reactive where Base : UIViewController
		{
		    var goNavigation: UIBindingObserver<Base, (path :String , para :[String: Any]?)> {
		        
		        return UIBindingObserver(UIElement: self.base, binding: { (vc, result) in
		            Navigator.open(result.path, result.para)
		        })
		    }
		}
	这是个简单的rx扩展实现，可以把它用作任何地方，这个很关键，你需要做的只是调整UIBindingObserver的初始化参数就行，他只能接受2个参数，所以后面那个自定义的就必须要用元组了
	
3. FreeStyle系列

		extension Reactive where Base : MGPayChooseViewController
		{
		    var payHeaderConfiguration: UIBindingObserver<Base, PayHeaderInfo> {
		        
		        return UIBindingObserver(UIElement: self.base, binding: { (vc, info) in
		            vc.payTitleLabel.text = info.payDescribe
		            vc.payPriceLabel.text = "\(info.payMoney)"
		        })
		    }
		 }
这样一个FreeStyle，就可以让你的代码看起来更整洁，因为所有对View的操作都会集中到这一个地方，而你的调用地方只需要：

        viewModel
            .payInfoDriver
            .bind(to: self.rx.payHeaderConfiguration)
            .disposed(by: disposeBag)
   这样就行了，这样那些复杂的处理逻辑就会集中到统一的地方，而你调用的地方就会显得简洁，之后查看其实你就不用关心你的调用处了，因为Rx习惯后你会发现，你的调用链一般不会错的，错的经常就是很杂七杂八给值的地方，也就是上面extension中可能会出现的
  
## 3 TableView扩展
1. 分组tableView

	为了省去protocol的对接，我们还是被自愿的用对象进行定义吧，把你的数据源转换成`[MGSection<ItemElement>]`这样的数组，而里面的`ItemElement`随意发挥了，因为Section其实只起个title的作用，因此直接将它封装了，有需求的后续会放开～比如数据源：
	
	    func sectionableData() -> Observable<[MGSection<MGItem>]> {
        let item1 = MGItem(str: "1")
        let item2 = MGItem(str: "2")
        let item3 = MGItem(str: "4")
        let item4 = MGItem(str: "5")

        let section1 = MGSection(header: "header1", items: [item1, item2])
        let section2 = MGSection(header: "header2", items: [item3, item4])

        return Observable.of([section1, section2])
   	    }
   	    
   	 是这样来的，那其实你只需要在tableView中作最傻瓜的绑定：
   	 
   	 
        viewModel
            .sectionableData()
            .bind(to: tableView) { (_, tableView, _, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = item.name
            return cell!
        }
        
       具体这个闭包里传什么，大家可以拿到代码后再看
       
      > 因为Section是引入了`RxDatasources`这个扩展进行再封装的，所以原有的一些方法在这个库中得到了优化，因此我们的选中事件还可以这样：
      
         tableView.rx
            .modelSelected(MGItem.self)
            .bind(to: self.rx.selectedMGItem)
            .disposed(by: disposeBag)
            
       这个好处就是你可以直接从调用链中获取到model了，而不是拿到个index然后再去找数组，其实就是不需要在viewModel中记录数组了～
       
       所以对于一维数组tableView，你还可以这么混搭着搞：
       
        viewModel
            .sectionableData().map { $0.flatMap { $0.items } }
            .bind(to: self.tableView.rx.items(cellIdentifier: "Cell")) {
                (_, demo: MGItem, cell) in
                cell.textLabel?.text = demo.name
        }.disposed(by: disposeBag)

        tableView.rx
            .modelSelected(MGItem.self)
            .bind(to: self.rx.selectedMGItem)
            .disposed(by: disposeBag)
            
     因为Datasource的建立实在太麻烦了，所以Rx原版的初始化+RxDatasources的选择是很好的选择
    
  
    
