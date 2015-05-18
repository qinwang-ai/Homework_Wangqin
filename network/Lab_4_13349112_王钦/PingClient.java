import java.io.*;
import java.net.*;
import java.util.*;

public class PingClient
{
	private static final int MAX_TIMEOUT = 1000;	// milliseconds
	
	public static void main(String[] args) throws Exception
	{
		long MAX_AVR_RTT = 0;	
		long MIN_AVR_RTT = 1001;	
		long SUM_RTT = 0;

		if (args.length != 1) {
			System.out.println("Required arguments: Server port");
			return;
		}
		int port = Integer.parseInt(args[0]);
		InetAddress server;
		server = InetAddress.getByName("127.0.0.1");

		DatagramSocket socket = new DatagramSocket( 5000);  // client self port
		int sequence_number = 0;
		while (sequence_number < 10) {
			Date now = new Date();
			long msSend = now.getTime();
			String str = "PING " + sequence_number + " " + msSend + " \n";
			byte[] buf = new byte[1024];
			buf = str.getBytes();
			DatagramPacket ping = new DatagramPacket( buf, buf.length, server, port);  //dest port
			socket.send(ping);
			try {
				socket.setSoTimeout( MAX_TIMEOUT);
				DatagramPacket response = new DatagramPacket(new byte[1024], 1024);
				socket.receive(response);

				now = new Date();
				long msReceived = now.getTime();
				long rtt = msReceived - msSend;
				if( rtt > MAX_AVR_RTT){
					MAX_AVR_RTT = rtt;
				}
				if( rtt < MIN_AVR_RTT){
					MIN_AVR_RTT = rtt;
				}
				SUM_RTT += rtt;
				printData(response, rtt);
			} catch (IOException e) {
				System.out.println("Timeout for packet " + sequence_number);
			}
			sequence_number ++;
		}
        System.out.println("MIN_AVR_RTT is "+MIN_AVR_RTT);
        System.out.println("MAX_AVR_RTT is "+MAX_AVR_RTT);
        System.out.println("AVR_RTTs is "+SUM_RTT/10.0);
	}

   private static void printData(DatagramPacket request, long delayTime) throws Exception
   {
      byte[] buf = request.getData();

      ByteArrayInputStream bais = new ByteArrayInputStream(buf);

      InputStreamReader isr = new InputStreamReader(bais);

      BufferedReader br = new BufferedReader(isr);

      String line = br.readLine();

      System.out.println(
         "Received from " +
         request.getAddress().getHostAddress() +
         ": " +
         new String(line) + " Delay: " + delayTime );
   }
}

