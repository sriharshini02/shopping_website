package servlets;


import java.io.*;


import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.io.PrintWriter;
import java.lang.*;



public  class  Login extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
		            throws ServletException, IOException {
		        response.setContentType("text/html;charset=UTF-8");
		        PrintWriter out = response.getWriter();
		        
		        String user = request.getParameter("user").trim();
		        String pass = request.getParameter("pass").trim();
		        
		        int user_id=Validate.checkUser_tologin(user, pass);
		        if(user_id>=1)
		        {
		        	
		        	 out.println("Welcome "+user);
		        	 response.sendRedirect("Products.jsp?user_id=" + user_id);
		        }
		        else
		        {
		        	
		            out.println("Username or Password incorrect");
		           RequestDispatcher rs = request.getRequestDispatcher("vindex.html");
		           rs.include(request, response);
		        }
		    }  

	}

