#include<bits/stdc++.h>
using namespace std;
using ll = long long;

ll mod(ll a,ll b){
    return (a-(b*(a/b)));
}
ll gcd(ll a, ll b){
    if(a<b) swap(a,b);
    if(b==0) return a;
    return gcd(b, mod(a, b));
}
int main(){
    cout<<"hi";
}