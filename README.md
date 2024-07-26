## Requirements
Parsing of HTML content and updating the assets:
- Create an API that receives the HTML document.
- Via a background job a service processes this HTML content picks up all assets, i.e. images, css and fonts, upload it to an S3 location and change the src of the original HTML document and saves it.
- When user fetches the document again via GET API - it will be served with updated source urls of the assets
- all the API communications should be authenticated via auth headers

## Installation and running
- Clone the git repo
- Using rbenv/rvm, install ruby version 3.3.2
- Run a bundle install
- The two exposed APIs are as follows

```
  POST /api/v1/html_documents HTTP/1.1
  Host: localhost:3000
  Authorization: Bearer <your_jwt_token>
  Content-Type: application/json

  {
    "content": "<html><body><img src='https://media.istockphoto.com/id/1471999877/photo/man-hand-on-laptop-with-exclamation-mark-on-virtual-screen-online-safety-warning-caution.webp?s=1024x1024&w=is&k=20&c=GJBFTIaUU2JpqJR2rZebE4q54Nxvf-qFlIGFIoPaUZc='><link rel='stylesheet' href='http://example.com/style.css'><script src='https://sdk.amazonaws.com/js/aws-sdk-2.1664.0.min.js'></script><video controls> <source src='https://www.w3schools.com/html/movie.mp4'  type='video/mp4'></video><audio controls> <source src='https://www.w3schools.com/html/horse.ogg' type='audio/ogg'></audio></body></html>"
  }
```

```
  GET /api/v1/html_documents/1 HTTP/1.1
  Host: localhost:3000
  Authorization: Bearer <your_jwt_token>

  Response:

  {
    "data": {
      "content": "<html><body><img src=\"https://storylane1.s3.eu-north-1.amazonaws.com/assets/813aecf0-7e08-4ae2-876a-f6a9cc82f8f8\"><link rel=\"stylesheet\" href=\"http://example.com/style.css\"><script src=\"https://storylane1.s3.eu-north-1.amazonaws.com/assets/a48790d1-c3fb-44c1-a97d-cfb41fb49515\"></script><video> <source src=\"https://storylane1.s3.eu-north-1.amazonaws.com/assets/33942e46-f7bd-40e9-a8ef-a97656e7f6f9\" type=\"video/mp4\"></source></video><audio> <source src=\"https://storylane1.s3.eu-north-1.amazonaws.com/assets/d72a66bf-9c14-449a-b7e6-4f145487ccc5\" type=\"audio/ogg\"></source></audio></body></html>",
      "processed_status": "parsed"
      }
  }
```

## Feature addition
- Allow s3-ing (uploading assets to s3) of locally defined file paths in HTML src attributes.
- Allow this html parsing and s3-ing of assets via an html url.
- Create a new model `ParsedDocumentLog` of some stats of a particular html document, like error in detail if failed, how many assets were found and parsed.
- Adding rspec for the APIs- Adding a serializer for show response- Adding a `description` column in `HtmlDocument` model to allow adding notes/summaries for a document.
- Adding a `doc_type` column to allow parsing of other types of documents, like XML- Retry logic for transient errors when uploading to S3.
- Process inline assets within CSS and JavaScript files.
- Extend support for other types of assets such as SVGs, iframes, and other embedded content.
- Add endpoints to list all uploaded assets and their metadata.
- Provide endpoints to delete or update existing HTML documents and their assets.

## Security concerns
- Encrypt sensitive data in transit and at rest.
- Implement more granular IAM policies to adhere to the principle of least privilege.
- Validate and sanitize the HTML content to prevent security vulnerabilities such as XSS attacks.

## Optimization
- Optimize the HTML processing to handle large documents efficiently.
- Use parallel processing for downloading and uploading assets to improve performance.
- Integrate with a CDN to serve the uploaded assets for better performance and lower latency.

## User Interface
- Build a GUI to manage and view processed HTML documents and their associated assets.
- Provide a dashboard to monitor the status of background jobs.

## Analytics and Reporting
- Implement analytics to track the usage and performance of the API.
- Generate reports on the types and sizes of assets processed, upload times, etc.

## Dockerize the application