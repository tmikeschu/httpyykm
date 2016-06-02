### HTTP? Yeah, You Know Me!

This project looked under the hood at HTTP GET and POST requests, utilizing a simple Ruby server to accept requests from browsers, cURL, and HTTP tools like Postman.

#### Usage

To run the server, from the root project folder run `ruby lib/httpyykm.rb` from your command line. This will run the server and keep it open until `Ctrl-C` or a GET request to the path `/shutdown` is run.

**The server runs at address http://127.0.0.1:9292**

The functionality of the server includes appropriate response codes and the following commands:

**GET Requests**<br>
* `/`
 * A request to the root returns debugging information that includes:
    * Verb
    * Path
    * Protocol
    * Host
    * Origin
    * Accept
    * Content-Length (POST requests only)
* `/hello`
  * Returns "Hello, World!" followed by the number of times that specific request has been run while the server is live.
* `/datetime`
  * Returns the current date and time in format: `11:07AM on Thursday, June 3, 2016`
* `/shutdown`
  * Responds with the total number of requests and causes the server to exit
* `/word_search?word=(your word here)`
  * Responds with `WORD if a known word` or `WORD is not a known word` depending on the results of a search through the built-in Mac OS dictionary file
* `/game`
  * If a game has been started, it will respond with how many guesses have been taken and whether the most recent guess was too low or too high.

**POST Requests**<br>
* `/`
  * Same functionality as outlined under GET requests
* `/start_game`
  * Responds with "Good luck!" and starts a game in which the computer has randomly chosen a number between 0 and 100. Guesses are passed in with...
* `/game?guess`
  * Pass your guess in via the body of the POST request. Your guess is stored on the server and a redirect is automatically issued for a GET request to `/game`, showing you your number of guesses and if your guess was correct, too high, or too low.
