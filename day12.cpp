#include <bits/stdc++.h>
// #define PART 1
#define PART 2

using namespace std;

void setIO(string name = "")
{
    ios_base::sync_with_stdio(0);
    cin.tie(0);
    if (name.size())
        freopen((name).c_str(), "r", stdin);
}

int main()
{
    setIO("data.txt");

    long long ans = 0;
    int N;
    cin >> N;
    for (int tc = 0; tc < N; tc++)
    {
        string s;
        cin >> s;

        // Part 2
        // repeat s five times
        if (PART == 2)
        {
            string t = s;
            for (int i = 0; i < 4; i++)
            {
                s += '?';
                s += t;
            }
        }

        s += '.';
        int n = s.size();
        string y;
        cin >> y;

        stringstream ss(y);
        vector<int> numbers;
        int number;
        int max_number = 0;
        while (ss >> number)
        {
            numbers.push_back(number);
            max_number = max(max_number, number);

            if (ss.peek() == ',')
                ss.ignore();
        }

        // Part 2
        // repeat numbers five times
        if (PART == 2)
        {
            vector<int> t_numbers = numbers;
            for (int i = 0; i < 4; i++)
            {
                numbers.insert(numbers.end(), t_numbers.begin(), t_numbers.end());
            }
        }

        int m = numbers.size();

        /*
        Define DP[i, j, k], where
            i is the index of the current character in s
            j is the index of the current number in numbers
            k is the current number of consecutive #s in s
            DP[i, j, k] is the number of ways for the first i characters in s to match
                the first j numbers in numbers, where the last k characters in s are consecutive #s
        Base case:
            DP[0, 0, 0] = 1
        Recurrence:
            DP[i + 1, j, k + 1] += DP[i, j, k] if s[i] == '#' or s[i] == '?' and k < numbers[j]
            DP[i + 1, j, 0] += DP[i, j, k] if s[i] == '.' or s[i] == '?' and k == 0
            DP[i + 1, j + 1, 0] += DP[i, j, k] if s[i] == '.' or s[i] == '?' and k == numbers[j]
        */
        vector<vector<vector<long long>>> dp(n + 1, vector<vector<long long>>(m + 2, vector<long long>(max_number + 2, 0)));
        dp[0][0][0] = 1;

        for (int i = 0; i <= n; i++)
        {
            for (int j = 0; j <= m; j++)
            {
                for (int k = 0; k <= max_number; k++)
                {
                    if (s[i] == '#' || s[i] == '?')
                    {
                        if (k < numbers[j])
                            dp[i + 1][j][k + 1] += dp[i][j][k];
                    }
                    if (s[i] == '.' || s[i] == '?')
                    {
                        if (k == 0)
                            dp[i + 1][j][0] += dp[i][j][k];
                        else if (k == numbers[j])
                            dp[i + 1][j + 1][0] += dp[i][j][k];
                    }
                }
            }
        }

        ans += dp[n][m][0];
    }

    cout << ans << endl;
}