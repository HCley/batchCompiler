package src.main.java.project.logger;

import src.main.java.project.app;

import java.io.FileNotFoundException;
import java.lang.StackTraceElement;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.nio.file.Paths;
import java.nio.file.Path;
import java.io.FileWriter;
import java.util.Scanner;
import java.lang.String;
import java.io.File;

import java.time.format.DateTimeFormatter;  
import java.time.LocalDateTime;    


public class Logger{
	private static PrintWriter logDataWriter;
	private static Path logDateTime;
	private static Logger instance;

	private static DateTimeFormatter time;

	private static final String command = "";
	private boolean printOnTerminal = app.printOnTerminal;

	private Logger(){
		DateTimeFormatter dt = DateTimeFormatter.ofPattern("dd-MM-yyyy_HH'H'.mm'M'.ss'S'");
		time = DateTimeFormatter.ofPattern("HH:mm:ss:SSS' - '"); 
        
        String filePath = Paths.get("").toAbsolutePath().toString();
        LocalDateTime now = LocalDateTime.now(); 
        filePath += "\\SavedLogs\\" + "LoggerRuntime_" + dt.format(now) + ".txt";   
        
        logDateTime =  Paths.get(filePath);
		String welcome = "";

		try{
			File logFile = new File(logDateTime.toString());

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
             System.err.format("Erro de E/S: %s%n", x);
        }
		
	}
	
	public static Logger getInstance() {
        if (instance == null)
            instance = new Logger();
        return instance;
    }


public void exception(Thread t, Throwable e){
		StackTraceElement[] stack = e.getStackTrace();
		String exception = "THROWN EXCEPTION\n" + e.getClass().getCanonicalName() + "\n";
		String message = e.getLocalizedMessage();

		if(message == null)
			message = "";
		else
			message += "\n";

		exception += "Thread "+ t.getId() +", " + t.getState() + "\n";
		exception += message + stack[0].toString() + "\n" + stack[stack.length-1].toString();

		publishLog(exception);
	}


	private void publishLog(String data){
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