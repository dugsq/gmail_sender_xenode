Gmail Sender Xenode
===================

**Gmail Sender Xenode** reads its input message context and data, composes an email message based on the input data, and sends the composed email through your gmail account. It leverages the "gmail" Ruby Gem to perform the email operations. The Xenode will read the attachment file from a local temporary folder based on the path and file information specified in the message context that it receives. The Gmail Sender Xenode will take multiple email addresses and send the composed email to every email address specified in the configuration. Email "To", "Subject", and "Body" can all be read from the either the configuration of the Xenode or from values specified within input message context.  

###Configuration File Options:###
* loop_delay: defines number of seconds the Xenode waits before running the Xenode process. Expects a float. 
* enabled: determines if the Xenode process is allowed to run. Expects true/false.
* debug: enables extra debug messages in the log file. Expects true/false.
* username: defines your gmail username. Expects a string.
* password: defines your gmail application access token / password. Expects a string.
* email_to: defines the email address to send an email to. Expects a string.
* email_subject: defines the subject of the email to compose. Expects a string.
* email_body: defines the body text of the email to compose. Expects a string.

###Example Configuration File:###
* enabled: false
* loop_delay: 30
* debug: false
* username: "jsmith@gmaildotcom"
* password: "abcdef123456"
* email_to: "jdoe@youremaildomaindotcom,jdoe2@youremaildomaindotcom"
* email_subject: "Scanned document"
* email_body: "Hello,\nAttached is a scanned copy of the document under discussion.\nPlease review, Thanks.\n"

###Example Input:###
* msg.context['file_path']: "tmp_dir/scan1.pdf" 
* msg.data:  "This string contains the actual body text of the email to be sent."

###Example Output:###
* The Gmail Sender Xenode does not generate any output.  
