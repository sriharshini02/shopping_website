package servlets;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class Validate extends HttpServlet {	
	
		public  static int insertUser(String user,String pass) {
			int userId=-1;
			try {
				   
				   final String jdbc_url = System.getenv("DB_JDBC_URL");
				   final String username = System.getenv("DB_USER");
				   final String password = System.getenv("DB_PASSWORD");
			    
				   Class.forName("com.mysql.cj.jdbc.Driver");
			         System.out.println("Username2 =" + user + "Password2 = " + pass);
			      Connection con = DriverManager.getConnection(jdbc_url, username, password);
			     PreparedStatement ps1 = con.prepareStatement("insert into user_auth_details (user,passwd) values( ?,?)");
			     ps1.setString(1, user);
			     ps1.setString(2, pass);
			     System.out.println("enter details into user_auth_details");
			     ps1.executeUpdate();
			     ps1.close();
			     

			     PreparedStatement ps2 = con.prepareStatement("select user_id from user_auth_details where user=? ");
			     ps2.setString(1, user);
			     ResultSet rs =ps2.executeQuery();
			     
			     if (rs.next()) {
			         userId = rs.getInt("user_id"); // Retrieve user_id from ResultSet
			     }

			     rs.close(); // Close the ResultSet after use
			     ps2.close(); // Close the PreparedStatement after use
			     System.out.println("Got the user_id from it");
			     
			     PreparedStatement ps3 = con.prepareStatement("update user_info set user_id = ? where user_id is null");
			     ps3.setInt(1, userId);
			     ps3.executeUpdate();
			     System.out.println("Entered user_id into it");	
			     ps3.close();
			    
			     }
			catch(Exception e) {
	            e.printStackTrace();
	        }
			 return userId;
			
		}
		 public static boolean checkUser_tosignup(String user,String pass) 
		{
		   boolean st =false;
		   try {
			   System.out.println("Username1 =" + user + "Password1 = " + pass);
			   final String jdbc_url = "jdbc:mysql://127.0.0.1:3306/webpage?allowPublicKeyRetrieval=true&useSSL=false";
			   final String username = "harshini";
			   final String password = "harshini";
		    //loading drivers for mysql
		       //  Class.forName("com.mysql.jdbc.Driver");
			   Class.forName("com.mysql.cj.jdbc.Driver");
		         System.out.println("Username2 =" + user + "Password2 = " + pass);
		    //creating connection with the database
		    // Connection con = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/test_projects","vishnu","vishnu"?useSSL=false");"
		       Connection con = DriverManager.getConnection(jdbc_url, username, password);
		     PreparedStatement ps = con.prepareStatement("select * from user_auth_details wher user=? ");
		     ps.setString(1, user);
		     System.out.println("Username3 =" + user + "Password3 = " + pass);
		     ResultSet rs =ps.executeQuery();
		     st = rs.next();
		     System.out.println("Username =" + user + "Password = " + pass);
		     }
		        catch(Exception e) {
		            e.printStackTrace();
		        }
		        return st;                 
		    } 
		 
		 public static int checkUser_tologin(String user,String pass) 
			{
			   int userId=-1;
			   try {
				   System.out.println("Username1 =" + user + "Password1 = " + pass);
				   final String jdbc_url = System.getenv("DB_JDBC_URL");
				   final String username = System.getenv("DB_USER");
				   final String password = System.getenv("DB_PASSWORD");
				   Class.forName("com.mysql.cj.jdbc.Driver");
			         System.out.println("Username2 =" + user + "Password2 = " + pass);
			    Connection con = DriverManager.getConnection(jdbc_url, username, password);
			     PreparedStatement ps = con.prepareStatement("select * from user_auth_details where user=? and passwd=?");
			     ps.setString(1, user);
			     ps.setString(2, pass);
			     System.out.println("Username3 =" + user + "Password3 = " + pass);
			     ResultSet rs =ps.executeQuery();
			     if (rs.next()) {
			         userId = rs.getInt("user_id"); // Retrieve user_id from ResultSet
			     }
			     else {
			    	 return -1;
			     }
			     System.out.println("Username =" + user + "Password = " + pass);
			     }
			        catch(Exception e) {
			            e.printStackTrace();
			        }
			        return userId;                 
			    }  
		 
		 
		
}
