#include <bits/stdc++.h>

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
    int N = 140;
    int M = 140;
    char grid[N][M];
    pair<int, int> gear_count[N][M];
    memset(gear_count, 0, sizeof(gear_count));
    for (int i = 0; i < N; i++)
    {
        string s;
        cin >> s;
        for (int j = 0; j < M; j++)
        {
            grid[i][j] = s[j];
        }
    }

    int ans = 0;

    for (int i = 0; i < N; i++)
    {
        int j = 0;
        for (; j < M;)
        {
            while (grid[i][j] < '0' || grid[i][j] > '9')
            {
                j++;
            }
            int num = 0;
            int start_j = j;
            while (grid[i][j] >= '0' && grid[i][j] <= '9')
            {
                num = num * 10 + (grid[i][j] - '0');
                j++;
            }
            bool ok = false;
            for (int k = start_j; !ok && k < j; k++)
            {
                vector<pair<int, int>> dirs = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}, {1, 1}, {-1, -1}, {-1, 1}, {1, -1}};
                for (auto dir : dirs)
                {
                    int x = i + dir.first;
                    int y = k + dir.second;
                    if (x >= 0 && x < N && y >= 0 && y < M)
                    {
                        if (grid[x][y] != '.' && (grid[x][y] < '0' || grid[x][y] > '9'))
                        {
                            ok = true;
                            if (grid[x][y] == '*')
                            {
                                gear_count[x][y].first++;
                                if (gear_count[x][y].second == 0)
                                    gear_count[x][y].second = 1;
                                gear_count[x][y].second *= num;
                            }
                            break;
                        }
                    }
                }
            }
            if (ok)
            {
                ans += num;
            }
        }
    }

    cout << ans << '\n';

    int ans2 = 0;

    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < M; j++)
        {
            if (grid[i][j] == '*')
            {
                if (gear_count[i][j].first == 2)
                    ans2 += gear_count[i][j].second;
            }
        }
    }

    cout << ans2 << '\n';
}