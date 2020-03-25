package src.main.java.project;

import src.main.java.project.FileManager.Writer;
import src.main.java.project.Exceptions.ExceptionHandler;

public class app {

	public static final boolean printOnTerminal = false;

	public static void main(String[] args) {
		Writer fileWriter = Writer.getInstance();
		log = log.getInstance();
		setExceptionWay();

		try{
			System.out.println("What is inside args: " + args[0]);
		} catch(Exception e){
			System.out.println("Working fine.");
		}	
	}

    private static void setExceptionWay(){
		Thread.setDefaultUncaughtExceptionHandler(new ExceptionHandler());
	}
}