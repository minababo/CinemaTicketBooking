<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Upcoming Movie</title>
</head>
<body>
<h1>Add Upcoming Movie</h1>
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
<form action=".//AddUpcomingServlet" method="POST">
    <label for="title">Movie Title:</label><br>
    <input type="text" id="title" name="title" required><br><br>

    <label for="description">Movie Description:</label><br>
    <textarea id="description" name="description" rows="5" required></textarea><br><br>

    <label for="image_url">Image URL:</label><br>
    <input type="text" id="image_url" name="image_url" required><br><br>

    <label for="release_date">Release Date:</label><br>
    <input type="date" id="release_date" name="release_date" required><br><br>

    <label>Trailer URL:</label><br>
    <input type="text" name="trailer_url" /><br><br>

    <button type="submit">Add Movie</button>
</form>
</body>
</html>