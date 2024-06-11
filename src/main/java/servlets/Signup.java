package servlets;


import java.io.*;



import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.io.PrintWriter;
import java.lang.*;



public  class  Signup extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
		            throws ServletException, IOException {
		        response.setContentType("text/html;charset=UTF-8");
		        PrintWriter out = response.getWriter();
		        
		        String user = request.getParameter("user").trim();
		        String pass = request.getParameter("pass").trim();
		        
		        Validate validate = new Validate();
		        
		        //out.println(user);
		        //out.println(pass);
		        
		        if(Validate.checkUser_tosignup(user, pass))
		        {
		        	out.println("Username already exists");
			           RequestDispatcher rs = request.getRequestDispatcher("vindex.html");
			           rs.include(request, response);
		        	 
		        }
		        else
		        {
		        	int user_id = Validate.insertUser(user,pass);
		        	out.println("Welcome "+user);
		        	response.sendRedirect("Products.jsp?user_id=" + user_id);
		        }
		    }  

	}

