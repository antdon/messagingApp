The front end of this app is named MVC because initially it was intended as an experiment with different architectural styles.
As the app expanded it didn't perfectly keep to MVC but you should be able to see the root of that in this project.
I will add screen shots when I get the chance but the app allows you to send instant messages to "Channels". 
All messages are global and right now all users are updated with the same list of channels.
There is no authentication so messages are linked to a username and if you change your usename you can populate a channel all on your own. 
The two things that are top of mind for the continuation of this project are:
    * AI summaries of the conversations in the channels. This would be using Apples new Foundation Models but hence awaits my upgrade to iOS26
    * Have the backend actually write to a database rather than just storing the messages in the server's memory
