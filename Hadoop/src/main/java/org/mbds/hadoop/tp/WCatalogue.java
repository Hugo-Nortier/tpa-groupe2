/*
  M2 MBDS - Big Data/Hadoop
	Ann??????e 2013/2014
  --
  TP1: exemple de programme Hadoop - compteur d'occurences de mots.
  --
  WCountMap.java: classe driver (contient le main du programme).
*/
package org.mbds.hadoop.tp;

import org.apache.hadoop.fs.Path;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.HashMap;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.util.GenericOptionsParser;
import org.apache.hadoop.io.Text;


// Note classe Driver (contient le main du programme Hadoop).
public class WCatalogue
{			
	// Le main du programme.
	public static void main(String[] args) throws Exception
	{
		// un object de configuration Hadoop.
		Configuration conf=new Configuration();
		// Arguments
		String[] ourArgs=new GenericOptionsParser(conf, args).getRemainingArgs();
		if(ourArgs.length!=4) {
			System.out.println("Nombre d'arguments invalide");
			System.exit(-1);
		}
		int typeAnalyse = 0;
		conf.set("file",args[0]);
		conf.set("catalogue",args[1]);
		String pwd = System.getProperty("user.dir");
		conf.set("path",pwd);

		String mapString="";
		conf.set("map",mapString);
		conf.setInt("org.mbds.hadoop.tp.typeAnalyse", typeAnalyse);
		conf.set(TextOutputFormat.SEPARATOR, ",");
		Job job=Job.getInstance(conf, "Compteur de mots v1.0");

		// Défini les classes driver, map et reduce.
		job.setJarByClass(WCatalogue.class);
		job.setMapperClass(WCatalogueMap.class);
		job.setReducerClass(WCatalogueReduce.class);

		// Défini types clefs/valeurs de notre programme Hadoop.
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(Text.class);
		
		
		// Défini les fichiers d'entrée du programme et le répertoire des résultats.
		// On se sert du premier et du deuxième argument restants pour permettre à l'utilisateur de les spécifier
		// lors de l'exécution.
		FileInputFormat.addInputPath(job, new Path(ourArgs[2])); //lire
		FileOutputFormat.setOutputPath(job, new Path(ourArgs[3])); //ecrire

		// On lance la tâche Hadoop. Si elle s'est effectuée correctement, on renvoie 0. Sinon, on renvoie -1.
		if(job.waitForCompletion(true)) {
			File f=new File(pwd+"/test.txt");
			FileReader fr = new FileReader(f);  
			BufferedReader br = new BufferedReader(fr);  
			String line;
			String[] lineSplit;
			HashMap<String,ArrayList<Float>>map=new HashMap<String,ArrayList<Float>>();
			Float bonus=0f;
			Float rejet=0f;
			Float energie=0f;
			
			while((line = br.readLine()) != null)
		      {
				lineSplit=line.split(";");
				String[] partie2=lineSplit[1].split(",");
				ArrayList<Float> floats=new ArrayList<Float>();
				floats.add(Float.parseFloat(partie2[0]));
				bonus+=Float.parseFloat(partie2[0]);
				floats.add(Float.parseFloat(partie2[1]));
				rejet+=Float.parseFloat(partie2[1]);
				floats.add(Float.parseFloat(partie2[2]));
				energie+=Float.parseFloat(partie2[2]);
				map.put(lineSplit[0], floats);
				}
			bonus=bonus/map.size();
			rejet=rejet/map.size();
			energie=energie/map.size();
			fr.close();
			f.delete();
			try {
				
	            // Recevoir le fichier 
	            Runtime rt = Runtime.getRuntime();
	            Process p=rt.exec("hdfs dfs -copyToLocal /finals .");
	            p.waitFor();
	            FileWriter fos = new FileWriter(pwd+"/finals/part-r-00000",true);
				f=new File(args[1]);
				fr = new FileReader(f);  
				br = new BufferedReader(fr);    
				line="";
				boolean premiereLigne=true;
				while((line = br.readLine()) != null)
			      {
					if(!premiereLigne) {
						lineSplit=line.split(",");
						if(!map.containsKey(lineSplit[0].toUpperCase())) {
							String res=lineSplit[0].toUpperCase();
							for(int i=1;i<lineSplit.length;i++) {
								res+=","+lineSplit[i];
							}
							fos.write(res+","+bonus+","+rejet+","+energie+"\n");
						}
					}else premiereLigne = false;
					
			      }
 	            fos.close();
 	           rt.exec("hdfs dfs -rm -r /finals");
 	          
	        }
	        catch (Exception e) {
	            System.err.println(e);
	        }
			
			br.close();
			System.exit(0);
		}
		System.exit(-1);
	}
}
