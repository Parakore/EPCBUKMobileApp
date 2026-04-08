import '../../auth/model/user_model.dart';
import '../model/user_mgmt_model.dart';

class UserRepository {
  Future<List<UserMgmtModel>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      UserMgmtModel(
        user: const UserModel(
          id: '1',
          name: 'Ramesh Kumar',
          email: 'ramesh@uk.gov.in',
          role: 'Applicant',
        ),
        district: 'Dehradun',
        status: 'Active',
        lastLogin: 'Today 14:32',
      ),
      UserMgmtModel(
        user: const UserModel(
          id: '2',
          name: 'Suresh Rawat',
          email: 'suresh@uk.gov.in',
          role: 'Forest Guard',
        ),
        district: 'Dehradun',
        status: 'Active',
        lastLogin: 'Today 12:44',
      ),
      UserMgmtModel(
        user: const UserModel(
          id: '3',
          name: 'Rajiv Sharma',
          email: 'rajiv@uk.gov.in',
          role: 'DFO',
        ),
        district: 'Dehradun',
        status: 'Active',
        lastLogin: 'Today 11:20',
      ),
      UserMgmtModel(
        user: const UserModel(
          id: '4',
          name: 'Priya Bisht',
          email: 'priya@uk.gov.in',
          role: 'UKPCB Officer',
        ),
        district: 'State HQ',
        status: 'Active',
        lastLogin: 'Today 10:15',
      ),
      UserMgmtModel(
        user: const UserModel(
          id: '5',
          name: 'Anand Verma',
          email: 'anand@uk.gov.in',
          role: 'DM',
        ),
        district: 'Dehradun',
        status: 'Active',
        lastLogin: 'Today 09:30',
      ),
    ];
  }
}
