#include <bits/stdc++.h>

using namespace std;

void setIO(string name = "")
{
    ios_base::sync_with_stdio(0);
    cin.tie(0);
    if (name.size())
        freopen((name).c_str(), "r", stdin);
}

// Chatgpt's parser
map<string, vector<vector<long long>>> parseInput()
{
    map<string, vector<vector<long long>>> parsedData;
    string line, key;

    while (getline(cin, line))
    {
        if (line.empty())
            continue; // Skip empty lines

        if (line.back() == ':')
        {
            // It's a key
            key = line.substr(0, line.size() - 1);
        }
        else
        {
            // It's a set of values
            istringstream iss(line);
            vector<long long> tuple;
            long long num;

            while (iss >> num)
            {
                tuple.push_back(num);
            }

            parsedData[key].push_back(tuple);
        }
    }

    return parsedData;
}

map<string, vector<vector<long long>>> parsedData;

vector<string> order = {
    "seed-to-soil map",
    "soil-to-fertilizer map",
    "fertilizer-to-water map",
    "water-to-light map",
    "light-to-temperature map",
    "temperature-to-humidity map",
    "humidity-to-location map"};

long long recurse(long long left, long long right, long long index)
{
    if (left > right)
        return __LONG_LONG_MAX__;
    if (index == 7)
        return left;

    set<pair<long long, long long>> ranges;
    long long ans = __LONG_LONG_MAX__;
    ranges.insert({left, right});

    auto m = &parsedData[order[index]];

    for (auto &i : *m)
    {
        bool dissected = true;
        while (dissected)
        {
            dissected = false;
            for (auto j : ranges)
            {
                auto [l, r] = j;

                long long dest = i[0];
                long long src = i[1];
                long long rg = i[2];

                long long leftr = max(l, src);
                long long rightr = min(r, src + rg - 1);
                if (leftr > rightr)
                    continue;
                ranges.erase(j);
                ranges.insert({l, leftr - 1});
                ranges.insert({rightr + 1, r});
                ans = min(ans, recurse(dest + (leftr - src), dest + (rightr - src), index + 1));
                dissected = true;
                break;
            }
        }
    }
    for (auto &j : ranges)
    {
        auto [l, r] = j;
        ans = min(ans, recurse(l, r, index + 1));
    }
    return ans;
}

int main()
{
    setIO("data.txt");

    parsedData = parseInput();

    vector<long long> seeds = parsedData["seeds"][0];

    long long ans = __LONG_LONG_MAX__;

    for (long long i = 0; i < seeds.size(); i += 2)
    {
        ans = min(ans, recurse(seeds[i], seeds[i] + seeds[i + 1] - 1, 0));
    }

    cout << ans << endl;

    return 0;
}