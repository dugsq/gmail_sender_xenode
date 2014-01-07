Gmail Sender Xenode
===================

Note: you will need the Xenograte Community Toolkit (XCT) to run this Xenode. Refer to the XCT repo [https://github.com/Nodally/xenograte-xct](https://github.com/Nodally/xenograte-xct) for more information.

**Gmail Sender Xenode** reads its input message context and data, composes an email message based on the input data, and sends the composed email through your gmail account. It leverages the "gmail" Ruby Gem to perform the email operations. The Xenode will read the attachment file from a local temporary folder based on the path and file information specified in the message context that it receives. The Gmail Sender Xenode will take multiple email addresses and send the composed email to every email address specified in the configuration. Email "To", "Subject", and "Body" can all be read from the either the configuration of the Xenode or from values specified within input message context.  

###Configuration File Options:###

* __`loop_delay`___: _Optional_; `Float`
  * defines number of seconds the Xenode waits before running the Xenode process. Expects a float. 
* __`enabled`__: _Optional_; `Boolean`
  * determines if the Xenode process is allowed to run. Expects true/false.
* `debug`: _Optional_; `Boolean`
  * enables extra debug messages in the log file. Expects true/false.
* `username`: _Mandatory_; 
  * defines your gmail username. Expects a string.
* `password`: _Mandatory_; 
  * defines your gmail application access token / password. Expects a string.
* `to`: _Mandatory_; 
  * defines the email address to send an email to. Expects a string.
* `subject`: _Mandatory_; 
  * defines the subject of the email to compose. Expects a string.
* `body`: _Mandatory_; 
  * defines the body text of the email to compose. Expects a string.
* `content_type`: _Optional_; String; 
  * 'html' OR 'plain'(default)
* `file_path`: _Optional_; String OR Array

###Example Configuration File:###
```yaml
debug: true
username: "jsmith@gmaildotcom"
password: "abcdef123456"
to: "jdoe@youremaildomaindotcom,jdoe2@youremaildomaindotcom"
subject: "Scanned document"
body: "Hello,\nAttached is a scanned copy of the document under discussion.\nPlease review, Thanks.\n"
```

###Example Input:###
* msg.context['file_path']: "tmp_dir/scan1.pdf" 
* msg.data:  "This string contains the actual body text of the email to be sent."

###Example Output:###
* The Gmail Sender Xenode does not generate any output.  
