
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  double _run;
  double _averageRun;
  int _changeDetail;
  int _expenseAll;
  int _expenseMonth;
  List _indicators = [];
  List _deletedIndicators=[];
  bool _loading;
  bool _nextPage;
  BuildContext _context;
  bool _sortChange;
  bool _sortRecent;
  bool _sortOfUser;
  bool _changed;
  bool _proAccount;
  String _nameOfCar ;
   String _number ;
  String _techPassport ;
  String _tenure;
  bool _clearMenu;
  bool _clearSettings;
  bool _NO_ACCOUNT;
  UserProvider.noAccount(){
    _NO_ACCOUNT = true;
    _loading = true;
    _nextPage = false;
    _sortChange = false;
    _sortRecent = false;
    _sortOfUser = false;
    _changed = false;
    _clearMenu = true;
    _clearSettings = false;
  }
  UserProvider.start(double run,double average,
      int changeDetails, int allExpense, int monthExpense, bool proAccount,
      String nameOfCar,String number,
      String techPassport, String tenure,
       bool clearSettings){
    if (proAccount == null){
      proAccount = false;
    }
    _run = run;
    _averageRun = average;
    _changeDetail = changeDetails;
    _expenseAll = allExpense;
    _expenseMonth =monthExpense;
    _loading = true;
    _nextPage = false;
    _sortChange = false;
    _sortRecent = false;
    _sortOfUser = false;
    _changed = false;
    _proAccount = proAccount;
    _nameOfCar = nameOfCar;
    _number = number;
    _techPassport = techPassport;
    _tenure = tenure;
    _clearMenu = !proAccount;
    _clearSettings = clearSettings;
    _NO_ACCOUNT = false;
  }

  UserProvider() {
    _run = 0;
    _averageRun = 0;
    _changeDetail = 0;
    _expenseAll = 0;
    _expenseMonth =0;
    _loading = true;
    _nextPage = false;
    _sortChange = false;
    _sortRecent = false;
    _sortOfUser = false;
    _changed = false;
    _proAccount = false;
    _nameOfCar = "";
    _number = "";
    _techPassport = "";
    _tenure = "";
    _clearMenu = true;
    _clearSettings = true;
    _NO_ACCOUNT = false;
  }
  bool get NO_ACCOUNT => _NO_ACCOUNT;
  bool get changed => _changed;
  bool get sortRecent => _sortRecent;
  bool get sortOfUser => _sortOfUser;
  List get deletedIndicators => _deletedIndicators;
  bool get sortChange => _sortChange;
  bool get nextPage => _nextPage;
  bool get loading => _loading;
  double get run => _run;
  double get averageRun => _averageRun;
  int get changeDetail => _changeDetail;
  int get expenseAll => _expenseAll;
  int get expenseMonth => _expenseMonth;
  List get indicators => _indicators;
  BuildContext get context => _context;
  bool get proAccount => _proAccount;
  String get nameOfCar =>_nameOfCar;
  String get number => _number;
  String get techPassport => _techPassport;
  String get tenure => _tenure;
  bool get clearSettings=>_clearSettings;
  bool get clearMenu => _clearMenu;

  void updateData(double run,double average,
      int changeDetails, int allExpense, int monthExpense, bool proAccount,
      String nameOfCar,String number,
      String techPassport, String tenure,
      bool clearSettings){
    _run = run;
    _averageRun = average;
    _changeDetail = changeDetails;
    _expenseAll = allExpense;
    _expenseMonth =monthExpense;
    _loading = true;
    _nextPage = false;
    _sortChange = false;
    _sortRecent = false;
    _sortOfUser = false;
    _changed = false;
    _proAccount = proAccount;
    _nameOfCar = nameOfCar;
    _number = number;
    _techPassport = techPassport;
    _tenure = tenure;
    _clearMenu = !proAccount;
    _clearSettings = clearSettings;
    _NO_ACCOUNT = false;
    notifyListeners();
  }
  void setNO_ACCOUNT(bool NO_ACCOUNT){
    _NO_ACCOUNT = NO_ACCOUNT;
    notifyListeners();
  }
  void setClearMenu(bool clearMenu){
    _clearMenu = clearMenu;
    notifyListeners();
  }
  void setClearSettings(bool clearSettings){
    _clearSettings = clearSettings;
    notifyListeners();
  }
  void setNameOfCar(String nameOfCar){
    _nameOfCar =nameOfCar;
    notifyListeners();
  }
  void setNumber(String number){
    _number = number;
    notifyListeners();
  }
  void setTechPassport(String techPassport){
    _techPassport = techPassport;
    notifyListeners();
  }
  void setTenure(String tenure){
    _tenure = tenure;
    notifyListeners();
  }
  void setProAccount(bool proAccount){
    _proAccount = proAccount;
    notifyListeners();
  }
  void setClean(){
    _deletedIndicators = [];
    notifyListeners();
  }
  void setChanged(bool changed){
    _changed = changed;
    notifyListeners();
  }
  void setSortRecent(bool sortRecent){
    _sortRecent = sortRecent;
    notifyListeners();
  }
  void setSortOfUser(bool sortOfUser){
    _sortOfUser = sortOfUser;
    notifyListeners();
  }
  void setSortChange(bool sortChange){
    _sortChange = sortChange;
    notifyListeners();
  }
  void setContext (BuildContext context){
    _context = context;
  }
  void setNextPage(bool nextPage){
    _nextPage = nextPage;
    notifyListeners();
  }
  void setLoading(bool loading){
    _loading = loading;
    notifyListeners();
  }
  void addIndicators(List add){
    _indicators.add(add);
    notifyListeners();
  }

  void setIndicators(List indicators){
    _indicators = indicators;
    notifyListeners();

  }
  void setRun(double run){
    _run = run;
    notifyListeners();
  }
  void setAverageRun(double averageRun){
    _averageRun = averageRun;
    notifyListeners();
  }
  void setChangeDetails(int changeDetail){
    _changeDetail = changeDetail;
    notifyListeners();
  }
  void setExpenseAll(int expenseAll){
    _expenseAll = expenseAll;
    notifyListeners();
  }

  void setExpenseMonth(int expenseMonth){
    _expenseMonth = expenseMonth;
    notifyListeners();
  }

}
