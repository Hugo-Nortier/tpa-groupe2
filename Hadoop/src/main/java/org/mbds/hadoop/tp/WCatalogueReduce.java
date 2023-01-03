/*
  M2 MBDS - Big Data/Hadoop
	Ann??????e 2013/2014
  --
  TP1: exemple de programme Hadoop - compteur d'occurences de mots.
  --
  WCountReduce.java: classe REDUCE.
*/
package org.mbds.hadoop.tp;

import org.apache.hadoop.io.Text;


import org.apache.hadoop.mapreduce.Reducer;

import java.util.ArrayList;
import java.util.Iterator;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;


// Notre classe REDUCE - templatee avec un type generique K pour la clef, un type de valeur IntWritable, et un type de retour
// (le retour final de la fonction Reduce) Text.
public class WCatalogueReduce extends Reducer<Text, Text, Text, Text>
{
	// La fonction REDUCE elle-meme. Les arguments: la clef key (d'un type generique K), un Iterable de toutes les valeurs
	// qui sont associees a la clef en question, et le contexte Hadoop (un handle qui nous permet de renvoyer le resultat a Hadoop).
  public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException
	{
	  Iterator<Text> i=values.iterator();
		float moyRejet=0;
		float moyBonus=0;
		float moyEnergie=0;
		int total=0;

		while(i.hasNext()) {
			Text ligne=i.next();
	        moyBonus +=Float.parseFloat(ligne.toString().split("_")[0]);
	        moyRejet +=Float.parseFloat(ligne.toString().split("_")[1]);
	        moyEnergie +=Float.parseFloat(ligne.toString().split("_")[2]);
	        total++;
		}
		
		moyRejet=moyRejet/total;
		moyBonus=moyBonus/total;
		moyEnergie=moyEnergie/total;
			
			String res="";
			String catalogue=context.getConfiguration().get("catalogue");
			File f=new File(catalogue);
			FileReader fr = new FileReader(f);  
			BufferedReader br = new BufferedReader(fr);  
			String line;
			String[] lineSplit;
			ArrayList<String>contenu=new ArrayList<String>();
			while((line = br.readLine()) != null)
		      {
				if(line.toUpperCase().contains(key.toString())) {
					contenu.add(key.toString());
					lineSplit=line.split(",");
					for(int j=1;j<lineSplit.length;j++) {
							res+=lineSplit[j]+",";
					}
					context.write(key, new Text(res+moyRejet+","+moyBonus+","+moyEnergie));
					res="";
				}
		      }
			try {
				if(contenu.contains(key.toString())) {
					 // Recevoir le fichier 
					String pwd=context.getConfiguration().get("path");
		            File f2 = new File(pwd+"/test.txt");
		            f2.createNewFile();
		            FileWriter fos = new FileWriter(f2,true);
	 	            fos.write(key.toString()+";"+moyRejet+","+moyBonus+","+moyEnergie+"\n");
	 	            fos.close();
				}
	        }
	        catch (Exception e) {
	            System.err.println(e);
	        }
			br.close();
			

  }
}