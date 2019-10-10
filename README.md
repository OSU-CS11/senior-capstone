# Senior-Capstone-CS11
A universal user input front-end for mobile devices:

Filling out forms on personal devices is a common and tedious task. Some users are comfortable with the devices keyboard and some avoid it at all cost. Sometimes the scale of the information that needs to be input makes keyboard entry overwhelming. Modern devices paired with off-the-shelf technologies are able to acquire information in a number of different ways. But no app or module exhaustively bundles all of these methods into a single module that can then be used by other app developers.

This project involves building a module that will generate text from any of the following methods:

+ from the devices keyboard
+ using optical character recognition by taking a picture of text written against a white background
+ converting handwriting to characters on a writing field contained on the devices screen using the finger as a stylus
+ using voice to text using the devices microphone
+ using a bar-code reader that accesses the devices camera
+ using morse-code in an audio file or encoded in a picture of bars and dots on a white background
…. possibly others

A single module bundles these independent input methods into one. The module publishes an API for an app which will call the module when a user encounters a text field in the calling app. It generates text from one of the methods above, as chosen by the user, and then communicates the resulting text back to the calling app’s text field. The successful project will place this module on some online marketplace for other app builders to use.
