
import java.io.*;
import java.util.*;

class FakeWriter
{
  public static void main(String[] args)
  {
    if (args.length != 3)
    {
      System.out.println("usage: FakeWriter iterations bytes filename");
      System.exit(1);
    }

    int itrns = Integer.parseInt(args[0]);
    int bytes = Integer.parseInt(args[1]);
    String name = args[2];
    System.out.println("iterations:   " + itrns);
    System.out.println("bytes/itrn:   " + bytes);
    System.out.println("total Mbytes: " + itrns*bytes/(1024*1024));
    System.out.println("writing file: " + name);

    OutputStream s = makeWriter(name);

    byte[] buffer = new byte[bytes];
    fill(buffer);

    go(itrns, buffer, s);
  }

  static OutputStream makeWriter(String name)
  {
    OutputStream s = null;
    try
    {
      s = new FileOutputStream(name);
      s.write("Header\n".getBytes());
    }
    catch (IOException e)
    {
      System.out.println(e);
      System.exit(1);
    }
    return s;
  }

  static void fill(byte[] buffer)
  {
    Random R = new Random();
    R.nextBytes(buffer);
  }

  static void go(int itrns, byte[] buffer, OutputStream s)
  {
    try
    {
      for (int i = 0; i < itrns; i++)
        s.write(buffer);
    }
    catch (IOException e)
    {
      System.out.println(e);
      System.exit(1);
    }
  }
}
