#include <iostream>
#include <string>
#include <vector>

using namespace std;

vector<string> split(const string &str, char delim);

int main()
{
  string text = "Thu Jan  1 00:00:00 UTC 1970";
  vector<string> vec;

  vec = split(text, ' ');

  for(vector<string>::iterator it = vec.begin(); it != vec.end(); ++it) {
    cout << *it << endl;
  }

  return 0;
}

vector<string> split(const string &str, char delim)
{
  vector<string> res;
  size_t current = 0, found;
  while((found = str.find_first_of(delim, current)) != string::npos) {
    if(found - current != 0) {
    res.push_back(string(str, current, found - current));
    }
    current = found + 1;
  }
  res.push_back(string(str, current, str.size() - current));
  return res;
}
