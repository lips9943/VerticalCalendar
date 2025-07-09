import UIKit

/// 캘린더 테마를 관리하는 모델입니다.
struct MyCalendarTheme {
    var backgroundColor: UIColor       // 캘린더 전체 백그라운드 컬러
    var cellLineColor: UIColor         // 셀 내부 선의 컬러
    var dayLabelColor: UIColor         // 평일 day label 기본 컬러
    var sundayColor: UIColor           // 일요일 day label 컬러
    var saturdayColor: UIColor         // 토요일 day label 컬러
    
    var headerTextColor: UIColor       // 섹션 헤더 텍스트 컬러
    var headerBackgroundColor: UIColor // 섹션 헤더 백그라운드 컬러
    
    var topBarTitleColor: UIColor      // TopBar의 제목 텍스트 컬러
    var topBarTitleFont: UIFont        // TopBar의 제목 폰트
    var dayLabelFont: UIFont           // Day label의 폰트
    var headerFont: UIFont             // 섹션 헤더의 폰트
    
    static let `default` = MyCalendarTheme(backgroundColor: .white,
                                           cellLineColor: .lightGray,
                                           dayLabelColor: .black,
                                           sundayColor: .red,
                                           saturdayColor: .blue,
                                           headerTextColor: .systemGray2,
                                           headerBackgroundColor: .white,
                                           topBarTitleColor: .black,
                                           topBarTitleFont: UIFont.boldSystemFont(ofSize: 24),
                                           dayLabelFont: UIFont.systemFont(ofSize: 16),
                                           headerFont: UIFont.boldSystemFont(ofSize: 16))
}
