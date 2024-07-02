
import org.apache.log4j.Logger;

class t1
{
  public static void main(String[] args)
  {
    Logger log = Logger.getLogger(t1.class.getName());
    log.info("Hello this is an info message");
    System.out.println("HELLO");
  }
}
