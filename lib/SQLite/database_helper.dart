import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../Json/account_json.dart';
import '../Json/activities_json.dart';
import '../Json/user.dart';

 class DatabaseHelper{

   int accountId = 0;
   int person = 0;
   final databaseName = "ladyteen1212.db";
   //Individuals
   String individuals = '''
   CREATE TABLE individuals (
   indId INTEGER PRIMARY KEY AUTOINCREMENT,
   indFullName TEXT NOT NULL,
   nationalId TEXT,
   jobTitle TEXT,
   indPhone TEXT,
   indEmail TEXT,
   indCardNumber TEXT,
   indCardName TEXT,
   profileImage TEXT,
   startedAt TEXT,
   endedAt TEXT
   )
   ''';

   //Account Category
   String accountCategory = '''
   CREATE TABLE accountCategory (
   accCategoryId INTEGER PRIMARY KEY AUTOINCREMENT,
   categoryName TEXT NOT NULL
   )
   ''';

   //Accounts
   String accounts = '''
   CREATE TABLE accounts (
   accId INTEGER PRIMARY KEY AUTOINCREMENT,
   accNumber INTEGER UNIQUE NOT NULL,
   accName TEXT NOT NULL,
   accHolder INTEGER,
   accStatus INTEGER,
   accCategory INTEGER,
   accDescription TEXT,
   accCreatedAt TEXT,
   accUpdatedAt TEXT,
   FOREIGN KEY (accCategory) REFERENCES accountCategory(accCategoryId),
   FOREIGN KEY (accHolder) REFERENCES individuals(indId)
   )
   ''';

   //Account Details
   String activities = '''
   CREATE TABLE activities (
   trnId INTEGER PRIMARY KEY AUTOINCREMENT,
   accountId INTEGER,
   debit REAL,
   credit REAL,
   trnCreatedAt TEXT,
   trnUpdatedAt TEXT,
   FOREIGN KEY (accountId) REFERENCES accounts (accId)
   )
   ''';

   //User Table
   String users = '''
   CREATE TABLE users (
   usrId INTEGER PRIMARY KEY AUTOINCREMENT,
   usrName TEXT UNIQUE NOT NULL,
   usrPassword TEXT NOT NULL,
   userOwner INTEGER,
   usrCreatedAt TEXT,
   usrUpdatedAt TEXT,
   FOREIGN KEY (userOwner) REFERENCES individuals (indId)
   )
   ''';

   //Default Data ---------------------------------------------------------------------

   String defaultInd = '''
    INSERT INTO individuals (indFullName) values ('system')
   ''';
   //Account Categories
   String defaultAccountCategory = '''
    INSERT INTO accountCategory (accCategoryId, categoryName)
    values 
    (1, 'customer'),
    (2, 'personnel'),
    (3, 'tailor'),
    (4, 'user'),
    (5, 'bank'),
    (6, 'expense'),
    (7, 'system'),
    (8, 'admin')
   ''';

   String defaultAccount = '''
   INSERT INTO accounts 
   (accNumber,accName, accStatus, accCategory, accDescription)
   values 
   (1,"assets",1,7,"assets"),
   (2,"benefits",1,7,"benefits"),
   (3,"treasure",1,7,"treasure"),
   (4,"unpaid",1,7,"unpaid"),
   (5,"unknown",1,7,"unknown")
   ''';


   Future<Database> initDB ()async{
     final databasePath = await getApplicationDocumentsDirectory();
     final path = "${databasePath.path}/$databaseName";
     return openDatabase(path,version: 1, onCreate: (db,version)async{

       //Tables ---------------------------------------------------------------------
       await db.execute(individuals);
       await db.execute(users);
       await db.execute(accountCategory);
       await db.execute(accounts);
       await db.execute(activities);

       //Default data ---------------------------------------------------------------
       //await db.execute(defaultInd);
       await db.execute(defaultAccountCategory);
       await db.execute(defaultAccount);
     });
   }


   //Authentications
   Future<bool> authenticate(Users users)async{
     final Database db = await initDB();
     var res = await db.rawQuery('select * from users where usrName = "${users.usrName}" AND usrPassword = "${users.usrPassword}" ');
     if(res.isNotEmpty){
       return true;
     }else{
       return false;
     }
   }


   //Get current user
   Future <Users?> getCurrentUser(String username)async{
     final Database db = await initDB();
     var res = await db.rawQuery('select usrId, usrName, usrPassword, fullName,roleName from users as a INNER JOIN accounts as b ON a.usrDetails = b.accId INNER JOIN usrRole as c ON a.role = c.roleId where usrName = ?',[username]);
     return res.isNotEmpty? Users.fromMap(res.first): null;
   }

   Future<List<AccountJson>> searchAccounts(String keyword)async{
     final db = await initDB();
     final List<Map<String, Object?>> result = await db.rawQuery(
         '''
        select 
        
        indId,
        indFullName,
        nationalId,
        indEmail,
        indPhone,
        jobTitle,
        indCardNumber,
        indCardName,
        
        accId,
        accNumber,
        accName,
        accDescription,
        accCreatedAt,
        accUpdatedAt,
        
        categoryName,
        
        trnId,
        trnCreatedAt,
        trnUpdatedAt,
        SUM(COALESCE(debit,0.0)) as totalDebit,
        SUM(COALESCE(credit,0.0)) as totalCredit
        
        from accounts as account 
        LEFT JOIN individuals as ind ON account.accHolder = ind.indId
        LEFT JOIN activities as trn ON account.accId = trn.accountId
        LEFT JOIN accountCategory as cat ON account.accCategory = cat.accCategoryId
        WHERE accName LIKE ? OR accNumber LIKE ?
        GROUP BY account.accNumber
       ''',
         ["%$keyword%","%$keyword%"]
     );
     return result.map((e) => AccountJson.fromMap(e)).toList();
   }

   Future<List<AccountJson>> getAccounts()async{
     final db = await initDB();
     final List<Map<String, Object?>> result = await db.rawQuery(
        '''
        select 
        
        indId,
        indFullName,
        nationalId,
        indEmail,
        indPhone,
        jobTitle,
        indCardNumber,
        indCardName,
        
        accId,
        accNumber,
        accName,
        accDescription,
        accCreatedAt,
        accUpdatedAt,
        
        categoryName,
        
        trnId,
        trnCreatedAt,
        trnUpdatedAt,
        SUM(COALESCE(debit,0.0)) as totalDebit,
        SUM(COALESCE(credit,0.0)) as totalCredit
        
        from accounts as account 
        LEFT JOIN individuals as ind ON account.accHolder = ind.indId
        LEFT JOIN activities as trn ON account.accId = trn.accountId
        LEFT JOIN accountCategory as cat ON account.accCategory = cat.accCategoryId
        WHERE accStatus = 1
        GROUP BY account.accNumber
       '''
     );
     return result.map((e) => AccountJson.fromMap(e)).toList();
   }

   Future<List<ActivitiesJson>> getActivities()async{
     final db = await initDB();
     final List<Map<String, Object?>> result = await db.rawQuery(
       '''
       select 
       accId,
       accNumber,
       trnId,
       SUM(debit) as debit,
       SUM(credit) as credit,
       SUM(credit) - SUM(debit) as balance
       from activities as trn
       INNER JOIN accounts as acc ON trn.accountId = acc.accId
       GROUP BY acc.accNumber
       '''
     );
     return result.map((e) => ActivitiesJson.fromMap(e)).toList();
   }


   Future<int> addAccount(int accHolder,int accCategory,String details)async{
     final db = await initDB();

     accountId = await db.rawInsert("INSERT INTO accounts (accNumber, accHolder, accStatus, accCategory, accDescription, accCreatedAt,accUpdatedAt) values ((select IFNULL(MAX(accNumber),99) +1 from accounts),?,?,?,?,?,?)",[accHolder,1,accCategory,details,DateTime.now().toIso8601String(),DateTime.now().toIso8601String()]);
     return accountId;
   }

   Future<int> addIndAccUser(fullName, nationalId, jobTitle, phone, email, cardNumber, cardName,String usrName, usrPassword)async{
     final db = await initDB();
     person = await db.rawInsert(''' 
     INSERT INTO individuals (indFullName,nationalId,jobTitle,indPhone,indEmail,indCardNumber,indCardName,startedAt)
     values (?,?,?,?,?,?,?,?)
     ''',[fullName, nationalId,jobTitle,phone,email,cardNumber,cardName,DateTime.now().toIso8601String()]);

     await db.rawInsert('''
      INSERT INTO accounts 
      (accNumber, accName, accHolder, accStatus, accCategory, accCreatedAt)
      values (?,?,?,?,?,?)
      ''',[100,fullName, person,1,8,DateTime.now().toIso8601String()]);

     await db.rawInsert( ''' 
     INSERT INTO users (usrName, usrPassword, usrCreatedAt,userOwner) 
     values (?,?,?,?)
     ''',[usrName,usrPassword,DateTime.now().toIso8601String(),person]);

     return person;
   }




 }