Gmail Sender Xenode
===================

Note: you will need the Xenograte Community Toolkit (XCT) to run this Xenode. Refer to the XCT repo [https://github.com/Nodally/xenograte-xct](https://github.com/Nodally/xenograte-xct) for more information.

**Gmail Sender Xenode** reads its input message context and data, composes an email message based on the input data, and sends the composed email through your gmail account. It leverages the "gmail" Ruby Gem to perform the email operations. The Xenode will read the attachment file from a local temporary folder based on the path and file information specified in the message context that it receives. The Gmail Sender Xenode will take multiple email addresses and send the composed email to every email address specified in the configuration. Email "To", "Subject", and "Body" can all be read from the either the configuration of the Xenode or from values specified within input message context.  

### Configuration Options:

* **enabled**: *Optional*; `Boolean`
  * determines if the Xenode process is allowed to run. Default is true.
* **debug**: *Optional*; `Boolean`
  * enables extra debug messages in the log file. Default is false.
* **username**: *Mandatory*; `String`
  * Gmail account (account email address).
* **password**: *Mandatory*; `String`
  * Gmail account password.
* **to**: *Mandatory*; `String` OR `Array`
  * email address to send an email to.
* **subject**: *Mandatory*; `String`
  * subject of the email.
* **body**: *Mandatory*; `String`
  * body text of the email.
* **content_type**: *Optional*; `String`
  * 'html' OR 'plain'. Default is 'html'
* **file_path**: *Optional*; `String` OR `Array`
  * file path for the attachment(s)

### Example Configuration File:
```yaml
debug: true
username: "jsmith@gmaildotcom"
password: "abcdef123456"
to: "jdoe@youremaildomaindotcom,jdoe2@youremaildomaindotcom"
subject: "Scanned document"
body: "Hello,\nAttached is a scanned copy of the document under discussion.\nPlease review, Thanks.\n"
```

### Example Input:
* msg.context['file_path']: "tmp_dir/scan1.pdf" 
* msg.data:  "This string will append to the body text of the email."

### Example Output:
* The Gmail Sender Xenode does not generate any output.  
