#include <iostream>
#include <string>
#include <regex>

using namespace std;

int main()
{
  string text = "Thu Jan  1 00:00:00 UTC 1970";
  regex ws_re("\\s+");

  sregex_token_iterator it_begin = sregex_token_iterator(text.begin(), text.end(), ws_re, -1);
  sregex_token_iterator it_end = sregex_token_iterator();

  for(sregex_token_iterator it = it_begin; it != it_end; it++) {
    cout << *it << endl;
  }

  return 0;
}
