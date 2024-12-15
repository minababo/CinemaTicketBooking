<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Home - ABC Cinemas</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap');

        body { font-family: 'Poppins', sans-serif; margin: 0; padding: 0; background-color: #010409; color: #cccccc }
        main { padding: 20px; text-align: center; }
        #carousel .slides {
            display: flex;
            transform: translateX(0);
        }
        #carousel img {
            object-fit: cover;
        }
    </style>
</head>
<body>
<!-- Navbar -->
<%@ include file="./navbar.jsp"%>

<!-- Page Content -->
</body>
</html>
