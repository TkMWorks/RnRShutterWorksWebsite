R&R ShutterWorks is my personal online photo gallery hosted in AWS. The images are manualy uploaded to a landing zone S3 bucket from where it is resized and uploaded to the final S3 bucket which hosts the HTML, CSS and JavaScript files. The website is hosted via CloudFront for CDN.

Tech Stack
------------
Front End:
  - HTML
  - CSS
  - JavaScript

Business Logic:
  - Python

Cloud Components:
  - S3 Buckets
  - Lambda Functions
  - Step Functions
  - SNS
  - SQS
  - CloudFront

Further Developments (WIP):
   - A .NET WinForms Application for Uploading the Images
