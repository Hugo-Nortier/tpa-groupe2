/*
  M2 MBDS - Big Data/Hadoop
	Ann??????e 2013/2014
  --
  TP1: exemple de programme Hadoop - compteur d'occurences de mots.
  --
  WCountMap.java: classe MAP.
*/
package org.mbds.hadoop.tp;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.LongWritable;
import java.util.ArrayList;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;


// Notre classe MAP.
public class WCatalogueMap extends Mapper<LongWritable, Text, Text, Text>
{

	// La fonction MAP elle-même.
	protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException
	{  
		String argumentFile=context.getConfiguration().get("file");
		File f=new File(argumentFile);
	    FileReader fr = new FileReader(f);  
	    BufferedReader br = new BufferedReader(fr);  
	    String line;
	    String cle = "";
	    ArrayList<String> liste = new ArrayList<String>();
	    while((line = br.readLine()) != null)
	      {
	    	  liste.add(line);   
	      }
	    br.close();
		String[] tokens = value.toString().split(",");
		int i=0;
		boolean test=false;
		while (i<liste.size() && !test){
			if (tokens[1].contains("^"+liste.get(i).toUpperCase())) {
				cle=liste.get(i);
				test=true;
			}
			i++;
		}
		// s'il trouve pas la marque dans la liste
		if (!test) {
			cle=tokens[1].split(" ")[0].replaceAll("\"", "");
		}		        
		        if(key.compareTo(new LongWritable(0))!=0 )
	              {
		        	if(tokens[tokens.length-3].equals("-6 000€ 1")) {
		        		tokens[tokens.length-3]="-6000";
		        	}
		         	if(tokens[tokens.length-3].equals("-")) {
		        		tokens[tokens.length-3]="0";
		        	}
				  String val= tokens[tokens.length-3].replaceAll("\\s+","").replaceAll("€", "").replaceAll(" ", "")+"_"+tokens[tokens.length-2]+"_"+tokens[tokens.length-1].replaceAll("\\s+","").replaceAll("\\t", "").replaceAll("€", "").replaceAll(" ", "");
	              context.write(new Text(cle), new Text(val));   
	             }
	}
}
