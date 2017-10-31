import MGBricks
import RxSwift
import Result

// MARK: - Demo api
internal class Demo {
    var name: String = ""

    static func buildDemos(on page: Int) -> [Demo] {
        var demos = [Demo]()

        print("hellolllll")

        for i in 1..<10 {
            let demo = Demo()
            demo.name = "page_\(page) : data__ \(i)"
            demos.append(demo)
        }

        return demos
    }

    static func buildPage(on page: Int) -> MGPage {
        let pageInfo = MGPage()
        pageInfo.currentPage = page
        pageInfo.totalPage = 3
        return pageInfo
    }
}

// MARK: - Demo service
internal class MockService: NSObject {
    func provideMock(on page: Int) -> Observable<Result<[Demo], MGAPIError>> {
        return Observable<Result<[Demo], MGAPIError>>.create({ observer -> Disposable in

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
             observer.onNext(Result(error: MGAPIError("errpr", message: "ssss")))

                //                observer.onNext(Result.init(value: Demo.buildDemos(on: 0)))
                observer.onCompleted()
            })

            return Disposables.create {

            }
        })
    }

    func providePageMock(on page: Int) -> Observable<Result<([Demo], MGPage), MGAPIError>> {
        return Observable<Result<([Demo], MGPage), MGAPIError>>.create({ observer -> Disposable in

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                //                observer.onNext(Result.init(error: MGAPIError(object: ["message" : "error lalala"])))
                print("request : \(page) times")
                observer.onNext(Result(error: MGAPIError("errpr", message: "ssss")))
//                observer.onNext(Result(value: (Demo.buildDemos(on: page), Demo.buildPage(on: page))))
                observer.onCompleted()
            })

            return Disposables.create {

            }
        })
    }
}
