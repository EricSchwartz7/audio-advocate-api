Audio Advocate (server side)
---
The app uses data gathered from pro audio retailers including Amazon, Sweetwater, and Guitar Center. Sort products based on average rating, number of ratings, and price, or filter by category. Product view features individual customer reviews and ratings.

Product card and review components were created using a ReactJS/Redux front end. The back end is a Rails API which handles the sorting and filtering of products based on different criteria. Data was gathered by scraping music retail websites using Nokogiri. All data is stored in a PostgreSQL database. Amazon’s Product Advertising API was used to generate iFrames containing reviews from Amazon.com.
