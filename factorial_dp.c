#include <iostream>

using namespace std;

int main() {
	int T,j,k;
	cin >> T;
	int N[T]; N[-1]=0;
	for(int i=0;i<T;i++){
	    cin>>N[i];
	    if(N[i]>N[i-1]) k=N[i]; else k=N[i-1];
	}
	//cout<<k;
    int x[k];
    
    x[0]=1;
    for(int i=0;i<T;i++){
        for(j=1;j<=N[i];j++){
            x[j]=j*x[j-1];
        }
        cout<<x[j-1]<<endl;
    }
}