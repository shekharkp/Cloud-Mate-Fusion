import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Securedstorage
{

  final storage = const FlutterSecureStorage();

  final AndroidOptions _securedata = const AndroidOptions(
      encryptedSharedPreferences: true
  );

  Future setLoginout(String isLogin) async
  {
    await storage.write(key: "isLogin", value: isLogin,aOptions: _securedata,);
    final value = await storage.read(key: "isLogin",aOptions: _securedata);
    print(value);
    return value;
  }

  Future getLoginout() async
  {
    final value = await storage.read(key: "isLogin",aOptions: _securedata)?? "Value not found";
    print(value);
    return value;
  }


  getuserID()async
  {
    final value = await storage.read(key: "UserID",aOptions: _securedata);
    print(value);
    return value;
  }

  setuserID(String userid)async
  {
    await storage.write(key: "UserID", value: userid,aOptions: _securedata);
    final value = await storage.read(key: "UserID", aOptions: _securedata);
    print(value);
    return value;
  }

  getConnectionStatus()async
  {
    final value = await storage.read(key: "connectionStatus",aOptions: _securedata);
    print(value);
    return value;
  }

  setConnectionStatus(String userid)async
  {
    await storage.write(key: "connectionStatus", value: userid,aOptions: _securedata);
    final value = await storage.read(key: "connectionStatus", aOptions: _securedata);
    print(value);
    return value;
  }

  gethostIP()async
  {
    final value = await storage.read(key: "hostIP",aOptions: _securedata);
    print(value);
    return value;
  }

  sethostIP(String hostIP)async
  {
    await storage.write(key: "hostIP", value: hostIP,aOptions: _securedata);
    final value = await storage.read(key: "hostIP", aOptions: _securedata);
    print(value);
    return value;
  }

  getusername()async
  {
    final value = await storage.read(key: "serverUserName",aOptions: _securedata);
    print(value);
    return value;
  }

  setusername(String serverUserName)async
  {
    await storage.write(key: "serverUserName", value: serverUserName,aOptions: _securedata);
    final value = await storage.read(key: "serverUserName", aOptions: _securedata);
    print(value);
    return value;
  }

}