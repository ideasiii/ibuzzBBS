<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
boolean checkResult = false;

session.setAttribute( "isLoginTag", checkResult );
session.setAttribute( "account", "" );
session.setAttribute( "password", "" );
%>
<%="ok"%>