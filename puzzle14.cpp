#include <iostream>
#include <fstream>
#include <string>
#include <map>
#include <iterator>
#include <list>

using namespace std;

long partOne() {
    string mask = "";
    long memPos = 0;
    string memVal = "";
    
    map<long, long> results;

    std::ifstream input("puzzle14[input]");
    for(std::string line; getline( input, line );) {
        if (line.rfind("mask", 0) == 0) {
            mask = line.substr(7);
        } else if (line.rfind("mem", 0) == 0) {
            memPos = std::stol(line.substr(4, line.find("]") - 4));
            memVal = std::bitset<36>(std::stoi(line.substr(line.find("]") + 4))).to_string();

            string newMemVal = "";

            for (int i = 0; i < 36; i++) {
                if (mask[i] != 'X') {
                    newMemVal += mask[i];
                } else {
                    newMemVal += memVal[i];
                }
            }

            results[memPos] = std::bitset<36>(newMemVal).to_ulong();
        }
    }

    long result = 0;
    map<long, long>::iterator itr;
    for (itr = results.begin(); itr != results.end(); ++itr) { 
        result += itr->second;
    }

    return result;
}

std::list<string> newBit(std::list<string> memPosList, string bit) {
    std::list<string> newMemPosLst;

    for (std::list<std::string>::const_iterator it = memPosList.begin(); it != memPosList.end(); ++it) {
        newMemPosLst.push_back(it->c_str() + bit);
    }

    if (memPosList.empty()) {
        newMemPosLst.push_back(bit);
    }

    return newMemPosLst;
}

long partTwo() {
    string mask = "";
    string memPos = "";
    long memVal = 0;
    
    map<long, long> results;

    std::ifstream input("puzzle14[input]");
    for(std::string line; getline(input, line);) {
        if (line.rfind("mask", 0) == 0) {
            mask = line.substr(7);
        } else if (line.rfind("mem", 0) == 0) {
            std::list<string> memPosList;
            memPos = std::bitset<36>(std::stoi(line.substr(4, line.find("]") - 4))).to_string();
            memVal = std::stol(line.substr(line.find("]") + 4));

            for (int i = 0; i < 36; i++) {
                if (mask[i] == 'X') {
                    std::list<string> newMemPosList0 = newBit(memPosList,  "0");
                    std::list<string> newMemPosList1 = newBit(memPosList,  "1");
                    newMemPosList0.merge(newMemPosList1);
                    memPosList = newMemPosList0;
                } else if (mask[i] == '1')  {
                    memPosList = newBit(memPosList,  "1");
                } else {
                    memPosList = newBit(memPosList,  std::string(1, memPos[i]));
                }
            }

            for (std::list<string>::iterator it = memPosList.begin(); it != memPosList.end(); ++it) {
                results[std::bitset<36>(it->c_str()).to_ulong()] = memVal;
            }
        }
    }

    long result = 0;
    map<long, long>::iterator itr;
    for (itr = results.begin(); itr != results.end(); ++itr) { 
        result += itr->second;
    }

    return result;
}

int main() {
    cout << "Part 1: " << partOne() << endl;
    cout << "Part 2: " << partTwo() << endl;
}