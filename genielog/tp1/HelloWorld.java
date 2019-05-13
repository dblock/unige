/*

TP1.GenieLog - 10.21.97 - Daniel Doubrovkine - doubrov5@cuimail.unige.ch

 job: get and output arguments from command line
    + average number of characters in arguments
    + number of arguments
    + quicksort algorithm for String[] arrays

*/
class HelloWorld {
  private static int average_len(String[] args){
    int sum = 0;
    for(int i=0;i<args.length;i++) sum+=(args[i]).length();
    if (args.length > 0) return(sum/args.length); else return(0);
  }
  private static void sort(String[] args){
    quickSort(args, 0, args.length - 1);
  }
  private static void swap(String[] a, int first, int second){
    String temp;
    temp = a[first];
    a[first] = a[second];
    a[second] = temp;
  }
  private static void quickSort(String[] a, int L, int U){
    int i, lastLow;
    String T;
    if(L < U){
      T = a[L];
      lastLow = L;
      for(i = L + 1; i <= U; ++i)
	if(a[i].compareTo(T) < 0){
	  lastLow++;
	  swap(a, lastLow, i);
	}
      swap(a, L, lastLow);
      quickSort(a, L, lastLow - 1);
      quickSort(a, lastLow + 1, U);


    }
  }
  public static void main(String[] args) {
    System.out.println("TP1.GenieLog :: D. Doubrovkine - uniGe - doubrov5@cuimail.unige.ch - 10.21.97");
    System.out.println("=============================================================================");
    System.out.println("total number of arguments: " + args.length);
    System.out.println("average length of arguments: " + average_len(args));
    if (args.length > 0){
      System.out.println("===========================================================================");
      System.out.println("unsorted arguments:");
      for(int i=0;i<args.length;i++) System.out.println("["+args[i]+"]");
      sort(args);
      System.out.println("sorted arguments:");
      for(int i=0;i<args.length;i++) System.out.println("["+args[i]+"]");
    }
  }
}

