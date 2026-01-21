<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>

    <html lang="en" dir="ltr">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>DevOps Project</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva;
                background-color: #f4f7f6;
                margin: 0;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
            }

            .container {
                background-color: #ffffff;
                padding: 2.5rem;
                border-radius: 12px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 450px;
                text-align: center;
            }

            h1 {
                color: #2c3e50;
                border-bottom: 2px solid #3498db;
                display: inline-block;
                margin-bottom: 10px;
            }

            h2 {
                color: #7f8c8d;
                font-size: 1.1rem;
                font-weight: 400;
                margin-bottom: 2rem;
            }

            .form-group {
                display: flex;
                flex-direction: column;
                gap: 15px;
            }

            input[type="text"] {
                padding: 12px;
                border: 2px solid #ddd;
                border-radius: 8px;
                outline: none;
                font-size: 1rem;
            }

            input[type="submit"] {
                background-color: #3498db;
                color: white;
                padding: 12px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: bold;
                font-size: 1rem;
            }

            input[type="submit"]:hover {
                background-color: #2980b9;
            }

            .result-box {
                margin-top: 20px;
                padding: 15px;
                background-color: #e8f4fd;
                border-left: 5px solid #3498db;
                border-radius: 4px;
                text-align: left;
            }
        </style>
    </head>

    <body>

        <div class="container">
            <h1>DevOps Project</h1>
            <h2>Welcome to our JSP Ap</h2>

            <form method="post" class="form-group">
                <input type="text" name="userText" placeholder="Type text here..." required />
                <input type="submit" value="Submit Data" />
            </form>

            <% /* Safe block comment */ String textOutput=request.getParameter("userText"); if (textOutput !=null &&
                !textOutput.trim().isEmpty()) { %>
                <div class="result-box">
                    You entered: <strong>
                        <%= textOutput %>
                    </strong>
                </div>
                <% } %>
        </div>

    </body>

    </html>