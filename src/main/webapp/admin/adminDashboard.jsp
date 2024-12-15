<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="styles.css">
    <script src="script.js"></script>
</head>
<body>
<h1>Admin Dashboard</h1>
<div class="admin-buttons">
    <h2>Admin Actions</h2>
    <button id="nowShowingBtn"><a href="addNowShowing.jsp">Add Now Showing Movie</a><br></button>
    <button id="upcomingBtn"><a href="addUpcoming.jsp">Add Upcoming Movie</a><br></button>
    <button id="manageMoviesBtn"><a href="addUpcoming.jsp">Manage Movies</a></button>
</div>
<div id="content"></div>
</body>
<script>
    document.getElementById('nowShowingBtn').addEventListener('click', function() {
        loadContent('nowShowing.jsp');
    });
    document.getElementById('upcomingBtn').addEventListener('click', function() {
        loadContent('upcoming.jsp');
    });
    document.getElementById('manageMoviesBtn').addEventListener('click', function() {
        loadContent('manageMovies.jsp');
    });

    function loadContent(url) {
        const xhr = new XMLHttpRequest();
        xhr.open('GET', url, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                document.getElementById('content').innerHTML = xhr.responseText;
            }
        };
        xhr.send();
    }
</script>
<div>

</div>
</html>
