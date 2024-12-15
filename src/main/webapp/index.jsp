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
<div id="carousel" style="width: 100%; height: 500px; overflow: hidden; position: relative; display: flex; align-items: center; justify-content: center;">
    <div class="slides" style="display: flex; transition: transform 0.5s ease; height: 100%;">
        <img src="./images/1.jpg" alt="Slide 1" style="width: 100%; flex-shrink: 0; object-fit: cover; height: 100%;">
        <img src="./images/2.jpg" alt="Slide 2" style="width: 100%; flex-shrink: 0; object-fit: cover; height: 100%;">
        <img src="./images/3.jpg" alt="Slide 3" style="width: 100%; flex-shrink: 0; object-fit: cover; height: 100%;">
    </div>
    <div id="navigation-buttons" style="position: absolute; bottom: 20px; left: 50%; transform: translateX(-50%); display: flex; gap: 10px;">
<button class="nav-btn" data-slide="0" style="width: 40px; height: 10px; background: #ccc; border: 1px solid #ccc; border-radius: 20px; cursor: pointer;"></button>
<button class="nav-btn" data-slide="1" style="width: 40px; height: 10px; background: #ccc; border: 1px solid #ccc; border-radius: 20px; cursor: pointer;"></button>
<button class="nav-btn" data-slide="2" style="width: 40px; height: 10px; background: #fff; border: 1px solid #ccc; border-radius: 20px; cursor: pointer;"></button>
    </div>
    <button id="prev" style="position: absolute; top: 0; left: 10px; height: 100%; background: rgba(255,255,255,0); border: 30px solid rgba(204,204,204,0); border-radius: 3px; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 40px; color: #fff;">&#10094;</button>
    <button id="next" style="position: absolute; top: 0; right: 10px; height: 100%; background: rgba(255,255,255,0); border: 30px solid rgba(204,204,204,0); border-radius: 3px; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 40px; color: #fff;">&#10095;</button>
</div>
<!-- Now Showing Movies -->
<h1 style="margin-left: 50px; margin-top:50px; color: #cccccc">Now Showing Movies</h1><br>
<!-- Now Showing Section -->
<section id="now-showing" style="padding: 20px; display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px;">
    <!-- Forward request to NowShowingServlet -->
    <jsp:include page="moviesection.jsp" />
</section>
<h1 style="margin-left: 50px; margin-top:10px; color: #cccccc">Upcoming Movies</h1><br>
<!-- Upcoming Movies Section -->
<section id="upcoming-movies" style="padding: 20px; display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px;">
    <!-- Include the dynamic upcoming movies section JSP -->
    <jsp:include page="upcomingsection.jsp" />
</section>
</body>
<script>
    let slideIndex = 0;
    const slides = document.querySelector(".slides");
    const navButtons = document.querySelectorAll(".nav-btn");
    const totalSlides = slides.children.length;
    updateNavButtons();

    document.getElementById("prev").onclick = () => {
        slideIndex = (slideIndex > 0) ? slideIndex - 1 : totalSlides - 1;
        updateCarousel();
    };

    document.getElementById("next").onclick = () => {
        slideIndex = (slideIndex < totalSlides - 1) ? slideIndex + 1 : 0;
        updateCarousel();
    };

    function updateCarousel() {
        slides.style.transform = `translateX(-${slideIndex * 100}%)`;
        updateNavButtons();
    }

    function updateNavButtons() {
        navButtons.forEach((btn, index) => {
            btn.style.background = (index === slideIndex) ? "#707070" : "#cccccc";
        });
    }

    navButtons.forEach((btn, index) => {
        btn.onclick = () => {
            slideIndex = index;
            updateCarousel();
        };
    });
    document.querySelectorAll(".watch-trailer-btn").forEach(button => {
        button.addEventListener("click", function() {
            const movie_id = this.getAttribute("data-movie-id");
            fetch(`./getTrailerLink.jsp?movie_id=${movie_id}`)
                .then(response => response.json())
                .then(data => {
                    const trailerPopup = document.createElement("div");
                    trailerPopup.style.position = "fixed";
                    trailerPopup.style.top = "50%";
                    trailerPopup.style.left = "50%";
                    trailerPopup.style.transform = "translate(-50%, -50%)";
                    trailerPopup.style.backgroundColor = "#fff";
                    trailerPopup.style.boxShadow = "0 4px 8px rgba(0, 0, 0, 0.2)";
                    trailerPopup.style.padding = "20px";
                    trailerPopup.style.zIndex = "1000";
                    trailerPopup.innerHTML = `
                            <iframe width="560" height="315" src="${data.trailerLink}" frameborder="0" allowfullscreen></iframe>
                           <button style="margin-top: 10px; padding: 10px 20px; background-color: #dc3545; color: white; border: none; border-radius: 5px; cursor: pointer;" id="closeTrailerPopup">Close</button>
                       `;
                    document.body.appendChild(trailerPopup);
                    document.getElementById("closeTrailerPopup").addEventListener("click", () => {
                        document.body.removeChild(trailerPopup);
                    });
                })
                .catch(error => console.error("Failed to load trailer:", error));
        });
    });
    document.querySelectorAll(".buy-tickets-btn").forEach(button => {
        button.addEventListener("click", function(event) {
            event.preventDefault();
            const bookingUrl = this.getAttribute("data-booking-url");
            window.location.href = bookingUrl;
        });
    });
</script>
</html>
