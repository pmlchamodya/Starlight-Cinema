<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movie Booking System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(to right, #4facfe, #00f2fe); /* Smooth gradient background */
            color: #333333;
        }
        .movie-card:hover {
            transform: translateY(-15px);
            box-shadow: 0 15px 25px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .navbar-link:hover {
            text-decoration: underline;
        }
        .carousel img {
            width: 100%;
            height: 450px;
            object-fit: cover;
            border-radius: 10px;
        }
        .bg-dark {
            background-color: #222222; /* Dark theme for footer and navbar */
        }
        .text-light {
            color: #e5e7eb; /* Light text for contrast */
        }
        .movie-card {
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
            transition: all 0.3s ease;
        }
        .movie-card img {
            border-radius: 10px;
        }
        .movie-card .title {
            font-size: 1.5rem;
            font-weight: bold;
            color: #1a202c;
        }
        .movie-card .genre {
            color: #3182ce;
            text-transform: uppercase;
            font-size: 1rem;
        }
        .movie-card .price {
            font-size: 1.25rem;
            font-weight: bold;
            color: #2d3748;
        }
        footer {
            background-color: #1f2937;
        }
        .icon {
            font-size: 1.25rem;
            margin-right: 0.5rem;
        }
        /* Navbar buttons */
        .navbar-btn {
            background-color: #3182ce; /* Button color */
            color: white;
            padding: 10px 20px;
            border-radius: 50px;
            transition: all 0.3s ease;
        }
        .navbar-btn:hover {
            background-color: #2c5282; /* Darker button color */
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
            transform: scale(1.05);
        }
        .navbar-link {
            text-transform: uppercase;
            font-weight: bold;
            letter-spacing: 1px;
        }

        /* Fade-in animation */
        @keyframes fadeIn {
            0% { opacity: 0; transform: translateY(20px); }
            100% { opacity: 1; transform: translateY(0); }
        }

        .fade-in {
            animation: fadeIn 1s ease-out;
        }

    </style>
</head>
<body class="bg-gray-100 min-h-screen flex flex-col">

<!-- Navbar -->
<nav class="bg-dark p-6 shadow-lg">
    <div class="max-w-6xl mx-auto flex justify-between items-center">
        <div class="flex items-center">
            <a href="index.jsp" class="text-light text-2xl font-bold navbar-link">Starlight Cinema</a>
        </div>
        <div class="space-x-6">
            <a href="index.jsp" class="navbar-btn">Home</a>
            <a href="contact.jsp" class="navbar-btn">Contact Us</a>
            <a href="about.jsp" class="navbar-btn">About Us</a>
            <%
                String loggedInUser = (String) session.getAttribute("username");
                if (loggedInUser != null) {
            %>
            <span class="text-light text-lg font-bold">Welcome <%= loggedInUser %>!</span>
            <%
            } else {
            %>
            <a href="login.jsp" class="navbar-btn">Login</a>
            <%
                }
            %>
        </div>
    </div>
</nav>


<!-- Carousel -->
<div class="carousel relative overflow-hidden max-w-6xl mx-auto my-8 rounded-lg shadow-lg">
    <div class="relative w-full">
        <div class="slide" style="display: block;">
            <img src="./img/1.jpg" alt="Movie 1">
        </div>
        <div class="slide" style="display: none;">
            <img src="./img/2.jpg" alt="Movie 2">
        </div>
    </div>
</div>

<script>
    const slides = document.querySelectorAll('.carousel .slide');
    let currentSlide = 0;

    setInterval(() => {
        slides[currentSlide].style.display = 'none'; // Hide current slide
        currentSlide = (currentSlide + 1) % slides.length; // Move to next slide
        slides[currentSlide].style.display = 'block'; // Show next slide
    }, 3000); // Change every 3 seconds
</script>

<!-- Main Content -->
<div class="flex-grow max-w-6xl mx-auto p-8">
    <h1 class="text-4xl font-extrabold text-white text-center mb-12 fade-in">Now Showing</h1>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/admindb", "root", "root");
                String query = "SELECT * FROM movies";
                PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    int movieId = rs.getInt("id");
                    String title = rs.getString("title");
                    int releaseYear = rs.getInt("release_year");
                    String description = rs.getString("description");
                    String trailerUrl = rs.getString("trailer_url");
                    String photoPath = rs.getString("photo_path");
                    String genre = rs.getString("genre");
                    double ticketPrice = rs.getDouble("ticket_price");
        %>
        <div class="movie-card bg-white shadow-lg rounded-lg overflow-hidden transition-transform transform hover:scale-105 fade-in">
            <img src="<%= photoPath %>" alt="<%= title %>" class="w-full h-60 object-cover rounded-t-lg">
            <div class="p-6">
                <h2 class="title"><%= title %> (<%= releaseYear %>)</h2>
                <p class="genre"><%= genre %></p>
                <p class="text-gray-700 text-sm mb-4 truncate"><%= description %></p>
                <div class="flex justify-between items-center">
                    <a href="<%= trailerUrl %>" target="_blank" class="text-blue-500 hover:underline font-medium">
                        <i class="fas fa-play icon"></i>Watch Trailer
                    </a>
                    <span class="price">$<%= ticketPrice %></span>
                </div>
                <a href="BookTickets.jsp?movie_id=<%= movieId %>"
                   class="mt-4 inline-block bg-yellow-500 text-white py-2 px-4 rounded hover:bg-yellow-600 text-center">
                    <i class="fas fa-ticket-alt icon"></i> Book Tickets
                </a>
            </div>
        </div>
        <%
                }
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p class='text-red-500 text-center'>Error loading movies: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</div>

<!-- Footer -->
<!-- Footer -->
<footer class="bg-dark text-light py-6 mt-auto">
    <div class="max-w-6xl mx-auto text-center">
        <p class="text-sm">
            <i class="fas fa-copyright"></i> 2024 Starlight Cinema. All rights reserved.
        </p>
        <div class="flex justify-center space-x-6 mt-4">
            <a href="#" class="text-light hover:text-yellow-400">
                <i class="fab fa-facebook-f"></i>
            </a>
            <a href="#" class="text-light hover:text-yellow-400">
                <i class="fab fa-twitter"></i>
            </a>
            <a href="#" class="text-light hover:text-yellow-400">
                <i class="fab fa-instagram"></i>
            </a>
        </div>
        <div class="mt-6">
            <a href="feedback.jsp"
               class="bg-yellow-500 text-white py-2 px-4 rounded hover:bg-yellow-600 transition-all">
                Review and Feedbacks
            </a>
        </div>
    </div>
</footer>


</body>
</html>
