package src.main.java.project.Exceptions;

import src.main.java.project.logger.Logger;
import java.lang.StackTraceElement;

public class ExceptionHandler implements Thread.UncaughtExceptionHandler {
	private static Logger log;

	@Override
	public void uncaughtException(Thread t, Throwable e){
		StackTraceElement[] a = e.getStackTrace();
		System.out.println("\nDeu ruim, meu consagrado!\n"+ e.getClass().getCanonicalName() +
						   "\n"+ a[0].toString() + "\n" + a[a.length-1].toString() + "\n");
		log = Logger.getInstance();
		log.exception(t, e);
	}
}