package src.main.java.project.FileManager;

import java.io.FileNotFoundException;
import java.lang.StackTraceElement;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.nio.file.Paths;
import java.nio.file.Path;
import java.nio.file.Files;
import java.io.FileWriter;
import java.util.Scanner;
import java.lang.String;
import java.io.File;

import java.time.format.DateTimeFormatter;  
import java.time.LocalDateTime;

import src.main.java.project.app;


public class Writer {
	private static Boolean printOnTerminal = app.printOnTerminal;
	private static PrintWriter logDataWriter;
	private static Path logDateTime;
	private static Writer instance;

	private static DateTimeFormatter time;

	private Writer () {
		DateTimeFormatter dt = DateTimeFormatter.ofPattern("dd-MM-yyyy_HH'H'.mm'M'.ss'S'");
		time = DateTimeFormatter.ofPattern("HH:mm:ss:SSS' - '"); 
        
        String folderPath = Paths.get("").toAbsolutePath().toString();
        folderPath += "\\SavedLogs\\";
        LocalDateTime now = LocalDateTime.now(); 
        String filePath = folderPath + "LoggerRuntime_" + dt.format(now) + ".txt";   
        
        logDateTime = Paths.get(filePath);
		String welcome = "";

		try{

			File logFile = new File(logDateTime.toString());
			if(Files.notExists(Paths.get(folderPath))){
				File folder = new File(folderPath);
				folder.mkdir();
			}

			if(!logFile.exists()){
            	logFile.createNewFile();

				welcome = "Logger file has been created on " +
						  logDateTime.subpath((logDateTime.getNameCount()-3), (logDateTime.getNameCount()-1)) + 
					 	  ",\nat file " +
	  					  logDateTime.getFileName() + ".";

				if(printOnTerminal)
					System.out.println(welcome + "\n");
			}
		
			logDataWriter = new PrintWriter(new FileWriter(logFile, true));
	        logDataWriter.println(welcome);

			String logEnviroment =
				"\nProcessor: "+System.getenv("PROCESSOR_IDENTIFIER") 	+ ". " +
				"\nComputer: " +System.getenv("COMPUTERNAME")	 		+ ", " +
				"User: " + 		System.getenv("USERNAME") 				+ "."  +
				"\nSystem: " +	System.getenv("OS") 					+ ", " +
								System.getenv("NUMBER_OF_PROCESSORS")	+ " Core(s)," +
				" v. " + 		System.getenv("PROCESSOR_REVISION") 	+ ".\n";

			logDataWriter.append(logEnviroment);		
	        logDataWriter.close();
        
        }catch(IOException x){
        	x.printStackTrace();
            System.err.format("Erro de E/S: %s%n", x);
        }
		
	}

	public static Writer getInstance(){
		if(instance == null)
			instance = new Writer();
		return instance;
	}

	public void publishLog(String data){
		if(data == null)
			return;

		try{
			File logFile = new File(logDateTime.toString());

			if(!logFile.exists()){
	        	logFile.createNewFile();
			
				if(printOnTerminal)
					System.out.println("New log file has been created: " + logDateTime.getFileName());
			}
		
			logDataWriter = new PrintWriter(new FileWriter(logFile, true));
	    
	    }catch(IOException x){
	         System.err.format("Erro de E/S: %s%n", x);
	    }

		data = data.replaceAll("\n", "\n               ");
		logDataWriter.append("\n" + time.format(LocalDateTime.now()) + data);
	    logDataWriter.close();
	}
}