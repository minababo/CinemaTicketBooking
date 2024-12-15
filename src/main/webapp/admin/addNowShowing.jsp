<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Now Showing Movie</title>
</head>
<body>
<h1>Add Now Showing Movies</h1>
    <%
    // Display error or success messages
    String error = request.getParameter("error");
    String success = request.getParameter("success");
    if (error != null) {
%>
<p style="color: red;"><%= error %></p>
    <%
    }
    if (success != null) {
%>
<p style="color: green;"><%= success %></p>
    <%
    }
%>
<form action="AddNowShowingServlet" method="POST">
    <div class="form">
        <label for="title">Movie Title:</label><br>
        <input type="text" id="title" name="title" required><br><br>

        <label for="description">Movie Description:</label><br>
        <textarea id="description" name="description" rows="5" required></textarea><br><br>

        <label for="image_url">Image URL:</label><br>
        <input type="text" id="image_url" name="image_url" required><br><br>

        <label for="trailer_url">Trailer URL:</label><br>
        <input type="text" id="trailer_url" name="trailer_url" required><br><br>

        <button type="submit">Add Movie</button>
    </div>
</form>