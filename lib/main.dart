import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CountrySearchPage(),
    );
  }
}

class CountrySearchPage extends StatefulWidget {
  const CountrySearchPage({Key? key}) : super(key: key);

  @override
  _CountrySearchPageState createState() => _CountrySearchPageState();
}

class _CountrySearchPageState extends State<CountrySearchPage> {
  final FocusNode _searchFocus = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final String SERVICE_URL = 'http://apis.data.go.kr/1262000/TravelWarningService/getTravelWarningList';
  final String SERVICE_KEY = '2nexDIuhuC5WFXZI9K5GzqivRwbKV0ygnmq96rxBo8f%2BM6xjdNyMqTt9RC%2Fvp5DXgvP9qVBNjOSZUAuAfMfLeQ%3D%3D';
  String selectedCountry = '';
  String selectedCountryIso = '';
  String selectedCountryIdx = '';
  String travelAlert = '';
  List<Map<String, String>> filteredCountries = [];
  String attentionNote = '';
  String controlNote  = '';
  String limitaNote = '';
  String banNote = '';
  String? imgUrl;
  String? imgUrl2;
  final int appBarBackgroundColor = 0xFF133E87;
  final int bodyBackgroundColor = 0xFFFFFFFF;
  final int drawerBackgroundColor = 0xFFFFFFFF;
  final int textColor = 0xFFFFFFFF;

  final List<Map<String, String>> countries = [
    {'iso': 'GHA', 'name': '가나', 'idx': '390'},
    {'iso': 'GAB', 'name': '가봉' , 'idx': '2'},
    {'iso': 'GUY', 'name': '가이아나', 'idx': '315'},
    {'iso': 'GMB', 'name': '감비아', 'idx': '5'},
    {'iso': 'GTM', 'name': '과테말라', 'idx': '7'},
    {'iso': 'GRD', 'name': '그레나다', 'idx': '316'},
    {'iso': 'GRC', 'name': '그리스', 'idx': '11'},
    {'iso': 'GIN', 'name': '기니', 'idx': '13'},
    {'iso': 'GNB', 'name': '기니비사우', 'idx': '14'},
    {'iso': 'NAM', 'name': '나미비아', 'idx': '15'},
    {'iso': 'NRU', 'name': '나우루', 'idx': '306'},
    {'iso': 'NGA', 'name': '나이지리아', 'idx': '18'},
    {'iso': 'SSD', 'name': '남수단', 'idx': '373'},
    {'iso': 'ZAF', 'name': '남아프리카공화국', 'idx': '20'},
    {'iso': 'NLD', 'name': '네덜란드', 'idx': '21'},
    {'iso': 'NPL', 'name': '네팔', 'idx': '22'},
    {'iso': 'NOR', 'name': '노르웨이', 'idx': '23'},
    {'iso': 'NZL', 'name': '뉴질랜드', 'idx': '25'},
    {'iso': 'NIU', 'name': '니우에', 'idx': '380'},
    {'iso': 'NER', 'name': '니제르', 'idx': '27'},
    {'iso': 'NIC', 'name': '니카라과', 'idx': '28'},
    {'iso': 'DNK', 'name': '덴마크', 'idx': '31'},
    {'iso': 'DOM', 'name': '도미니카공화국', 'idx': '33'},
    {'iso': 'DMA', 'name': '도미니카연방', 'idx': '369'},
    {'iso': 'DEU', 'name': '독일', 'idx': '34'},
    {'iso': 'TLS', 'name': '동티모르', 'idx': '304'},
    {'iso': 'LAO', 'name': '라오스', 'idx': '36'},
    {'iso': 'LBR', 'name': '라이베리아', 'idx': '37'},
    {'iso': 'LVA', 'name': '라트비아', 'idx': '344'},
    {'iso': 'RUS', 'name': '러시아', 'idx': '39'},
    {'iso': 'LBN', 'name': '레바논', 'idx': '40'},
    {'iso': 'LSO', 'name': '레소토', 'idx': '370'},
    {'iso': 'ROU', 'name': '루마니아', 'idx': '43'},
    {'iso': 'LUX', 'name': '룩셈부르크', 'idx': '337'},
    {'iso': 'RWA', 'name': '르완다', 'idx': '45'},
    {'iso': 'LBY', 'name': '리비아', 'idx': '375'},
    {'iso': 'LTU', 'name': '리투아니아', 'idx': '345'},
    {'iso': 'LIE', 'name': '리히텐슈타인', 'idx': '48'},
    {'iso': 'MDG', 'name': '마다가스카르', 'idx': '49'},
    {'iso': 'MHL', 'name': '마셜제도', 'idx': '307'},
    {'iso': 'MAC', 'name': '마카오', 'idx': '378'},
    {'iso': 'MWI', 'name': '말라위', 'idx': '55'},
    {'iso': 'MYS', 'name': '말레이시아', 'idx': '56'},
    {'iso': 'MLI', 'name': '말리', 'idx': '57'},
    {'iso': 'MEX', 'name': '멕시코', 'idx': '58'},
    {'iso': 'MCO', 'name': '모나코', 'idx': '341'},
    {'iso': 'MAR', 'name': '모로코', 'idx': '60'},
    {'iso': 'MUS', 'name': '모리셔스', 'idx': '61'},
    {'iso': 'MRT', 'name': '모리타니아', 'idx': '62'},
    {'iso': 'MOZ', 'name': '모잠비크', 'idx': '63'},
    {'iso': 'MNE', 'name': '몬테네그로', 'idx': '290'},
    {'iso': 'MDA', 'name': '몰도바', 'idx': '65'},
    {'iso': 'MDV', 'name': '몰디브', 'idx': '309'},
    {'iso': 'MLT', 'name': '몰타', 'idx': '297'},
    {'iso': 'MNG', 'name': '몽골', 'idx': '68'},
    {'iso': 'USA', 'name': '미국', 'idx': '69'},
    {'iso': 'MMR', 'name': '미얀마', 'idx': '75'},
    {'iso': 'FSM', 'name': '미크로네시아연방', 'idx': ''},
    {'iso': 'VUT', 'name': '바누아투', 'idx': '310'},
    {'iso': 'BHR', 'name': '바레인', 'idx': '288'},
    {'iso': 'BRB', 'name': '바베이도스', 'idx': '318'},
    {'iso': 'BHS', 'name': '바하마', 'idx': '339'},
    {'iso': 'BGD', 'name': '방글라데시', 'idx': '82'},
    {'iso': 'BEN', 'name': '베냉', 'idx': '289'},
    {'iso': 'VEN', 'name': '베네수엘라', 'idx': '85'},
    {'iso': 'VNM', 'name': '베트남', 'idx': '86'},
    {'iso': 'BEL', 'name': '벨기에', 'idx': '87'},
    {'iso': 'BLR', 'name': '벨라루스', 'idx': '333'},
    {'iso': 'BLZ', 'name': '벨리즈', 'idx': '319'},
    {'iso': 'BIH', 'name': '보스니아헤르체고비나', 'idx': '298'},
    {'iso': 'BWA', 'name': '보츠와나', 'idx': '91'},
    {'iso': 'BOL', 'name': '볼리비아', 'idx': '92'},
    {'iso': 'BDI', 'name': '부룬디', 'idx': '93'},
    {'iso': 'BFA', 'name': '부르키나파소', 'idx': '94'},
    {'iso': 'BTN', 'name': '부탄', 'idx': '329'},
    {'iso': 'BGR', 'name': '불가리아', 'idx': '98'},
    {'iso': 'BRA', 'name': '브라질', 'idx': '104'},
    {'iso': 'BRN', 'name': '브루나이', 'idx': '105'},
    {'iso': 'WSM', 'name': '사모아', 'idx': '112'},
    {'iso': 'SAU', 'name': '사우디아라비아', 'idx': '107'},
    {'iso': 'SMR', 'name': '산마리노', 'idx': '299'},
    {'iso': 'STP', 'name': '상투메프린시페', 'idx': '371'},
    {'iso': 'SEN', 'name': '세네갈', 'idx': '114'},
    {'iso': 'SRB', 'name': '세르비아', 'idx': '287'},
    {'iso': 'SYC', 'name': '세이셸', 'idx': '291'},
    {'iso': 'SOM', 'name': '소말리아', 'idx': '120'},
    {'iso': 'SLB', 'name': '솔로몬제도', 'idx': '311'},
    {'iso': 'SDN', 'name': '수단', 'idx': '122'},
    {'iso': 'SUR', 'name': '수리남', 'idx': '323'},
    {'iso': 'LKA', 'name': '스리랑카', 'idx': '124'},
    {'iso': 'SWE', 'name': '스웨덴', 'idx': '126'},
    {'iso': 'CHE', 'name': '스위스', 'idx': '127'},
    {'iso': 'ESP', 'name': '스페인', 'idx': '128'},
    {'iso': 'SVK', 'name': '슬로바키아', 'idx': '129'},
    {'iso': 'SVN', 'name': '슬로베니아', 'idx': '130'},
    {'iso': 'SYR', 'name': '시리아', 'idx': '131'},
    {'iso': 'SLE', 'name': '시에라리온', 'idx': '292'},
    {'iso': 'SGP', 'name': '싱가포르', 'idx': '134'},
    {'iso': 'ARE', 'name': '아랍에미리트', 'idx': '135'},
    {'iso': 'ARM', 'name': '아르메니아', 'idx': '334'},
    {'iso': 'ARG', 'name': '아르헨티나', 'idx': '138'},
    {'iso': 'ISL', 'name': '아이슬란드', 'idx': '139'},
    {'iso': 'HTI', 'name': '아이티', 'idx': '324'},
    {'iso': 'IRL', 'name': '아일랜드', 'idx': '141'},
    {'iso': 'AZE', 'name': '아제르바이잔', 'idx': '335'},
    {'iso': 'AFG', 'name': '아프가니스탄', 'idx': '284'},
    {'iso': 'AND', 'name': '안도라', 'idx': '340'},
    {'iso': 'ALB', 'name': '알바니아', 'idx': '300'},
    {'iso': 'DZA', 'name': '알제리', 'idx': '150'},
    {'iso': 'AGO', 'name': '앙골라', 'idx': '151'},
    {'iso': 'ATG', 'name': '앤티가바부다', 'idx': '325'},
    {'iso': 'ERI', 'name': '에리트레아', 'idx': '338'},
    {'iso': 'EST', 'name': '에스토니아', 'idx': '154'},
    {'iso': 'ECU', 'name': '에콰도르', 'idx': '155'},
    {'iso': 'ETH', 'name': '에티오피아', 'idx': '156'},
    {'iso': 'SLV', 'name': '엘살바도르', 'idx': '157'},
    {'iso': 'GBR', 'name': '영국', 'idx': '159'},
    {'iso': 'YEM', 'name': '예멘', 'idx': '294'},
    {'iso': 'OMN', 'name': '오만', 'idx': '162'},
    {'iso': 'AUS', 'name': '호주', 'idx': '255'},
    {'iso': 'AUT', 'name': '오스트리아', 'idx': '163'},
    {'iso': 'HND', 'name': '온두라스', 'idx': '164'},
    {'iso': 'JOR', 'name': '요르단', 'idx': '165'},
    {'iso': 'UGA', 'name': '우간다', 'idx': '166'},
    {'iso': 'URY', 'name': '우루과이', 'idx': '167'},
    {'iso': 'UZB', 'name': '우즈베키스탄', 'idx': '168'},
    {'iso': 'UKR', 'name': '우크라이나', 'idx': '169'},
    {'iso': 'IRQ', 'name': '이라크', 'idx': '174'},
    {'iso': 'IRN', 'name': '이란', 'idx': '176'},
    {'iso': 'ISR', 'name': '이스라엘', 'idx': '177'},
    {'iso': 'EGY', 'name': '이집트', 'idx': '178'},
    {'iso': 'ITA', 'name': '이탈리아', 'idx': '179'},
    {'iso': 'IND', 'name': '인도', 'idx': '285'},
    {'iso': 'IDN', 'name': '인도네시아', 'idx': '181'},
    {'iso': 'JPN', 'name': '일본', 'idx': '183'},
    {'iso': 'JAM', 'name': '자메이카', 'idx': '326'},
    {'iso': 'ZMB', 'name': '잠비아', 'idx': '186'},
    {'iso': 'GNQ', 'name': '적도기니', 'idx': '187'},
    {'iso': 'GEO', 'name': '조지아', 'idx': '332'},
    {'iso': 'CAF', 'name': '중앙아프리카공화국', 'idx': '190'},
    {'iso': 'TWN', 'name': '대만', 'idx': '372'},
    {'iso': 'CHN', 'name': '중국', 'idx': '189'},
    {'iso': 'DJI', 'name': '지부티', 'idx': '191'},
    {'iso': 'ZWE', 'name': '짐바브웨', 'idx': '193'},
    {'iso': 'TCD', 'name': '차드', 'idx': '295'},
    {'iso': 'CZE', 'name': '체코', 'idx': '195'},
    {'iso': 'CHL', 'name': '칠레', 'idx': '197'},
    {'iso': 'CMR', 'name': '카메룬', 'idx': '199'},
    {'iso': 'CPV', 'name': '카보베르데', 'idx': '200'},
    {'iso': 'KAZ', 'name': '카자흐스탄', 'idx': '201'},
    {'iso': 'QAT', 'name': '카타르', 'idx': '202'},
    {'iso': 'KHM', 'name': '캄보디아', 'idx': '259'},
    {'iso': 'CAN', 'name': '캐나다', 'idx': '204'},
    {'iso': 'KEN', 'name': '케냐', 'idx': '206'},
    {'iso': 'COM', 'name': '코모로', 'idx': '331'},
    {'iso': 'CRI', 'name': '코스타리카', 'idx': '209'},
    {'iso': 'CIV', 'name': '코트디부아르', 'idx': '212'},
    {'iso': 'COL', 'name': '콜롬비아', 'idx': '213'},
    {'iso': 'COG', 'name': '콩고', 'idx': '214'},
    {'iso': 'COD', 'name': '콩고민주공화국', 'idx': '215'},
    {'iso': 'CUB', 'name': '쿠바', 'idx': '327'},
    {'iso': 'KWT', 'name': '쿠웨이트', 'idx': '216'},
    {'iso': 'COK', 'name': '쿡제도', 'idx': '330'},
    {'iso': 'HRV', 'name': '크로아티아', 'idx': '218'},
    {'iso': 'KGZ', 'name': '키르기스스탄', 'idx': '301'},
    {'iso': 'KIR', 'name': '키리바시', 'idx': '312'},
    {'iso': 'CYP', 'name': '키프로스', 'idx': ''},
    {'iso': 'THA', 'name': '태국', 'idx': '260'},
    {'iso': 'TJK', 'name': '타지키스탄', 'idx': '302'},
    {'iso': 'TZA', 'name': '탄자니아', 'idx': '225'},
    {'iso': 'TUR', 'name': '터키', 'idx': ''},
    {'iso': 'TGO', 'name': '토고', 'idx': '296'},
    {'iso': 'TON', 'name': '통가', 'idx': '230'},
    {'iso': 'TKM', 'name': '투르크메니스탄', 'idx': '366'},
    {'iso': 'TUV', 'name': '투발루', 'idx': '313'},
    {'iso': 'TUN', 'name': '튀니지', 'idx': '233'},
    {'iso': 'TTO', 'name': '트리니다드토바고', 'idx': '328'},
    {'iso': 'PAN', 'name': '파나마', 'idx': '235'},
    {'iso': 'PRY', 'name': '파라과이', 'idx': '237'},
    {'iso': 'PAK', 'name': '파키스탄', 'idx': '239'},
    {'iso': 'PNG', 'name': '파푸아뉴기니', 'idx': '240'},
    {'iso': 'PLW', 'name': '팔라우', 'idx': '314'},
    {'iso': 'PSE', 'name': '팔레스타인', 'idx': '398'},
    {'iso': 'PER', 'name': '페루', 'idx': '243'},
    {'iso': 'PRT', 'name': '포르투갈', 'idx': '244'},
    {'iso': 'POL', 'name': '폴란드', 'idx': '246'},
    {'iso': 'FRA', 'name': '프랑스', 'idx': '248'},
    {'iso': 'FJI', 'name': '피지', 'idx': '249'},
    {'iso': 'FIN', 'name': '핀란드', 'idx': '251'},
    {'iso': 'PHL', 'name': '필리핀', 'idx': '252'},
    {'iso': 'HUN', 'name': '헝가리', 'idx': '254'},
    {'iso': 'HKG', 'name': '홍콩', 'idx': '377'},
  ];

  @override
  void initState() {
    super.initState();

    // 위젯 빌드 후 FocusNode에 포커스를 주기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocus);
    });
  }

  void filterCountries(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredCountries = [];
      });
      return;
    }

    setState(() {
      filteredCountries = countries
          .where((country) => country['name']?.toLowerCase().contains(query.toLowerCase().trim()) ?? false)
          .toList();
    });
  }

  Future<void> setTravelAlertData(String country) async {
    // 초기화
    attentionNote = '';
    controlNote  = '';
    limitaNote = '';
    banNote = '';
    imgUrl = null;
    imgUrl2 = null;
    travelAlert = '';

    final Map<String, String?> result = await fetchTravelAlert(country);
    print(result);

    if (result.isEmpty) {
      setState(() {
        travelAlert = '$selectedCountry의 여행경보 정보가 없습니다.';
      });
      return;
    }

    setState(() {
      attentionNote = result['attentionNote'] ?? '없음';
      controlNote = result['controlNote'] ?? '없음';
      limitaNote = result['limitaNote'] ?? '없음';
      banNote = result['banNote'] ?? '없음';
      imgUrl = result['imgUrl'];
      imgUrl2 = result['imgUrl2'];

      /*travelAlert = [
        if (attentionNote.isNotEmpty) '여행유의(1단계) : $attentionNote',
        if (controlNote.isNotEmpty) '여행자제(2단계) : $controlNote',
        if (limitaNote.isNotEmpty) '철수권고(3단계) : $limitaNote',
        if (banNote.isNotEmpty) '여행금지(4단계) : $banNote',
      ].join('\n');*/
    });
  }

  Future<Map<String, String?>> fetchTravelAlert(String country) async {
    http://apis.data.go.kr/1262000/TravelWarningService/getTravelWarningList?serviceKey=serviceKey&countryName=countryName
    http://apis.data.go.kr/1262000/TravelWarningService/getTravelWarningList?serviceKey=serviceKey&isoCode1=isoCode1

    // API 호출
    final Map<String, String?> result = {};
    try {
      // 1. API 호출
      final String URL = '$SERVICE_URL?serviceKey=$SERVICE_KEY&isoCode1=$country';
      print('URL: $URL');

      final response = await http.get(
        Uri.parse(URL),
      );

      if (response.statusCode == 200) {
        // 2. XML 문자열 파싱
        final decodedResponse = utf8.decode(response.bodyBytes);
        final document = xml.XmlDocument.parse(decodedResponse);
        // print(document.toXmlString(pretty: true));

        // findAllElements로 특정 태그를 모두 찾기
        final element = document.findAllElements('item').first;
        result.addAll({
          'countryName': element.findElements('countryName').singleOrNull?.text, // 국가명
          'countryEnName': element.findElements('countryEnName').singleOrNull?.text, // 국가명
          'continent': element.findElements('continent').singleOrNull?.text, // 대륙
          'wrtDt': element.findElements('wrtDt').singleOrNull?.text, // 등록일
          'attention': element.findElements('attention').singleOrNull?.text, // 여행유의
          'attentionPartial': element.findElements('attentionPartial').singleOrNull?.text, // 여행유의(일부)
          'attentionNote': element.findElements('attentionNote').singleOrNull?.text, // 여행유의 내용
          'control': element.findElements('control').singleOrNull?.text, // 여행자제
          'controlPartial': element.findElements('controlPartial').singleOrNull?.text, // 여행자제(일부)
          'controlNote': element.findElements('controlNote').singleOrNull?.text, // 여행자제 내용
          'limita': element.findElements('limita').singleOrNull?.text, // 철수권고
          'limitaPartial': element.findElements('limitaPartial').singleOrNull?.text, // 철수권고(일부)
          'limitaNote': element.findElements('limitaNote').singleOrNull?.text, // 철수권고 내용
          'banYna': element.findElements('banYna').singleOrNull?.text, // 여행금지
          'banYnPartial': element.findElements('banYnPartial').singleOrNull?.text, // 여행금지(일부)
          'banNote': element.findElements('banNote').singleOrNull?.text, // 여행금지 내용
          'imgUrl': element.findElements('imgUrl').singleOrNull?.text,  // 국가 이미지
          'imgUrl2': element.findElements('imgUrl2').singleOrNull?.text, // 여행위험지도
          'isoCode': element.findElements('isoCode').singleOrNull?.text, // ISO 코드
        });
      }
    } catch (e) {
      print('Error parsing XML: $e');
    }
    return result;
  }

  Widget _buildTravelAlertCard(String title, String note, Color color, Color textColor, String tooltipMessage) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 4),
              Tooltip(
                message: tooltipMessage,
                triggerMode: TooltipTriggerMode.tap,
                child: Icon(Icons.info, color: textColor, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            note,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showWebViewPopup(BuildContext context, String url, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            child: WebViewExample(url: url, title: title),
          );
      },
    );
  }

  void _showWebView(BuildContext context, String url, String title) {
    // Navigator.pop(context); // Drawer를 닫습니다.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
        WebViewExample(
          url: url,
          title: title,
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(appBarBackgroundColor),
        title: Row(
          children: [
            Icon(Icons.public, color: Color(textColor)),
            SizedBox(width: 8),
            Text(
              '여행경보 검색',
              style: TextStyle(
                color: Color(textColor),
              ),
            ),
          ],
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Color(textColor),),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: Color(drawerBackgroundColor),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(appBarBackgroundColor),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(textColor)),
                    SizedBox(width: 8),
                    Text(
                      '외교부 여행 정보',
                      style: TextStyle(
                        color: Color(textColor),
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('여행경보제도'),
              onTap: () {
                _showWebView(context, 'https://www.0404.go.kr/walking/walking_intro.jsp', '여행경보제도');
              },
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('단계별 여행경보'),
              onTap: () {
                _showWebView(context, 'https://www.0404.go.kr/dev/issue_current.mofa', '단계별 여행경보');
              },
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('특별여행주의보'),
              onTap: () {
                _showWebView(context, 'https://www.0404.go.kr/dev/special_issue_current.mofa', '특별여행주의보');
              },
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('위기상황별 대처매뉴얼'),
              onTap: () {
                _showWebView(context, 'https://www.0404.go.kr/country/manual.jsp', '위기상황별 대처매뉴얼');
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(bodyBackgroundColor),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                focusNode: _searchFocus,
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: '국가 검색',
                  hintText: '검색할 국가를 입력해 주세요',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: (value) {
                  filterCountries(value);
                },
              ),
            ),
            if (filteredCountries.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCountries.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text(filteredCountries[index]['name']!),
                      ),
                      onTap: () {
                        setState(() {
                          selectedCountry = filteredCountries[index]['name']!;
                          selectedCountryIso = filteredCountries[index]['iso']!;
                          selectedCountryIdx = filteredCountries[index]['idx']!;
                          _searchController.text = selectedCountry;
                          filteredCountries = [];
                        });
                        setTravelAlertData(selectedCountryIso);
                        
                        // 키보드 내리기
                        _searchFocus.unfocus();
                      },
                    );
                  },
                ),
              ),
            if (selectedCountry.isNotEmpty && filteredCountries.isEmpty)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                selectedCountry,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (imgUrl != null) ...[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    imgUrl!,
                                    height: 70,
                                    // width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                              if (travelAlert.isNotEmpty)
                                Text(
                                  travelAlert,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              if (travelAlert.isEmpty) ...[
                                const SizedBox(height: 16),
                                _buildTravelAlertCard('1단계 여행유의', attentionNote, const Color(0xff026abf), Colors.white, '국내 대도시보다 상당히 높은 수준의 위험'),
                                const SizedBox(height: 10),
                                _buildTravelAlertCard('2단계 여행자제', controlNote, const Color(0xfffcc33c), Colors.black, '국내 대도시보다 매우 높은 수준의 위험'),
                                const SizedBox(height: 10),
                                _buildTravelAlertCard('3단계 출국권고', limitaNote, const Color(0xffc82613), Colors.white, '국민의 생명과 안전을 위협하는 심각한 수준의 위험'),
                                const SizedBox(height: 10),
                                _buildTravelAlertCard('4단계 여행금지', banNote, const Color(0xff292929), Colors.white, '국민의 생명과 안전을 위협하는 매우 심각한 수준의 위험'),
                              ]
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (imgUrl2 != null)
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: Container(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height * 0.7,
                                    child: InteractiveViewer(
                                      panEnabled: true,
                                      boundaryMargin: EdgeInsets.all(20),
                                      minScale: 0.5,
                                      maxScale: 4,
                                      child: Image.network(
                                        imgUrl2!,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Image.network(
                            imgUrl2!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 16),
                      if (selectedCountryIdx.isNotEmpty)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                            backgroundColor: Color(appBarBackgroundColor),
                          ),
                          onPressed: () {
                            _showWebViewPopup(context, 'https://www.0404.go.kr/dev/country_view.mofa?idx=$selectedCountryIdx', '여행경보 상세정보');
                          },
                          child: const Text(
                            '조회된 정보가 없거나 더 많은 정보를 원하시면 여기를 터치해 주세요',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: AdMobComponent(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose(); // FocusNode 해제
    super.dispose();
  }
}

class WebViewExample extends StatefulWidget {
  final String url;
  final String title;

  const WebViewExample({
    required this.url,
    required this.title
  });

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  InAppWebViewController? webViewController;
  String url = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            webViewController?.canGoBack().then((value) {
              if (value) {
                webViewController?.goBack();
              } else {
                Navigator.of(context).pop();
              }
            });
          },
        ),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.url)),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            clearCache: true,
            javaScriptCanOpenWindowsAutomatically: true,
            mediaPlaybackRequiresUserGesture: false,
          ),
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          webViewController = controller;
        },
        onLoadStart: (controller, url) {
          setState(() {
            this.url = url.toString();
          });
        },
      ),
      // bottomNavigationBar: AdMobComponent(),
    );
  }
}

class AdMobComponent extends StatefulWidget {
  @override
  _AdMobComponentState createState() => _AdMobComponentState ();
}

class _AdMobComponentState extends State<AdMobComponent> {
  BannerAd? _bannerAd;  // 배너 광고 객체 생성
  bool _isBannerAdLoaded = false; // 광고 로딩 여부 확인 변수

  @override
  void initState() {
    super.initState();
    _loadBannerAd();  // 배너 광고 로드
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-4660704022375249/4394796767',
      size: AdSize.fullBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Banner Ad Failed to Load: $error');
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isBannerAdLoaded ? SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ) : const SizedBox(),
    );
  }
}
