import java.awt.List;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

public class tag {
  
	int index ,indecies = 0;;
	public Map<String,Integer> Dictionary = new HashMap<String,Integer>();
	ArrayList<Integer> integers = new ArrayList<Integer>();
	public Map<Integer,String> Dic = new HashMap <Integer, String>();
	int count = 0;
	
	void SetIndex(int ind)
	{
		this.index = ind;
	}
	int GetIndex()
	{
	  return this.index;	
	}
	
	
	public void Compress(String word) throws IOException
	{
		
		FileWriter to = new FileWriter("Compress1.txt");
		BufferedWriter outfile  = new BufferedWriter(to);
		
		String Next = word.valueOf(word.charAt(0));
		
		int mountOfI = 0;
		
		for(int i = 0 ; i < word.length() && i + mountOfI < word.length() ;i++)
		{	
		
		  i+= mountOfI;	
		  Next = word.valueOf(word.charAt(i));
		 // System.out.println(Next);
		  if(Dictionary.get(Next) == null)
		  {
			 if(Next.length() == 1)
			 {
				 char c = Next.charAt(0);
				 Dictionary.put(Next , (int) c);
				 integers.add((int)c);
				 indecies++;
				 if(i+1 < word.length()){
				 Next+= word.charAt(i+1);
				 Dictionary.put(Next , count + 128);
				 count++;
				 mountOfI = 0;
				 }
			 }
		   }
		
		  else
		  {
			  if(i == (word.length() - 1))
			  {
				  if(Next.length() == 1)
				  integers.add(Dictionary.get(Next.substring(0, Next.length())));
			  }
			 int increase = 1;
			 mountOfI =0;
			 if(i + increase < word.length())
			   Next+= word.charAt(i+ increase);
			for(int j = i+1 ; j < word.length(); j++)
			{
				if(Dictionary.get(Next) == null)
				{
					
					Dictionary.put(Next ,count+128);
					integers.add(Dictionary.get(Next.substring(0, Next.length()-1)));
					count++;
					break;
				}
				else
				{
					increase++;
					if(i + increase < word.length())
					Next+= word.charAt(i + increase);
					mountOfI++;
					if((i+increase) == ( word.length()))
					{
					   
						integers.add(Dictionary.get(Next));
						break;
					}
				}
			 }
		   }
		 }
		
		for(int i = 0 ; i < integers.size(); i++)
		{
			//System.out.println(integers.get(i));
			try{
			outfile.write(String.valueOf(integers.get(i)));
			outfile.write("-");
			}
			catch( IOException e){
				 e.printStackTrace();
			}
		}
		outfile.close();
    }
	
	////////////////////////////////////////////////////EXTRACT////////////////////////////////////////////////////////////////
	
	public void Decompress(String word) throws IOException
	{
		String Final = new String();
		String previous = new String();
		String temp = new String();
		String[] numbers = word.split("-");
		int[] num = new int[numbers.length];
		count = 0;
		
		for(int i = 0 ; i < numbers.length; i++)
		{
			num[i] = Integer.parseInt(numbers[i]);
		}
		
		for(int  i = 0 ; i < num.length ; i++)
		{	    	
			previous = null;
			if(num[i] < 128)
			{
				String c = String.valueOf((char)num[i]);
				Dic.put( num[i] , c);
				Final += c;
				//System.out.println(Final + "     "+ num[i]);
			}
			
			else if(num[i] >= 128 && Dic.get(num[i]) == null )
			{
				 
				  String local = Dic.get(num[i - 1]);
				  local += Dic.get(num[i - 1]).charAt(0);
				  Dic.put(num[i] , local);
				  Final += local;
				  
			}
			
			else
    		{
  			  Final += Dic.get(num[i]); 
			}
			if( i >= 1)
			{
				temp = Dic.get(num[i - 1]);
				temp+= Dic.get(num[i]).charAt(0);
				Dic.put(count + 128 , temp);
				count++;
			}
		}
		FileWriter to = new FileWriter("Devoke.txt");
		BufferedWriter outfile  = new BufferedWriter(to);
		System.out.println(Final);
		Final = Final.toString();
        outfile.write(Final);
        outfile.close();
	}
	}
