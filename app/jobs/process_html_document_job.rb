class ProcessHtmlDocumentJob < ApplicationJob
  queue_as :default

  def perform(html_document_id)
    html_document = HtmlDocument.find_by(id: html_document_id)
    return unless html_document.present?

    html_document.in_process!

    doc = Nokogiri::HTML(html_document.content)

    process_assets(doc, 'img', 'src') # Process images
    process_assets(doc, 'script', 'src') # Process JavaScript files
    process_assets(doc, 'video', 'src') # Process video files
    process_assets(doc, 'video source', 'src') # Process video files
    process_assets(doc, 'audio', 'src') # Process video files
    process_assets(doc, 'audio source', 'src') # Process video files

    html_document.update(content: doc.inner_html.gsub("\n", "").gsub("\"", "'"))
    html_document.parsed!
  end

  private

  def process_assets(doc, selector, attribute)
    doc.css(selector).each do |element|
      next unless element[attribute]

      uri = element[attribute]
      response = fetch_content(uri)
      next unless response.status.success?

      s3_url = Utils::AwsS3.upload_to_s3("assets", response.body.to_s, response.content_type.mime_type)
      element[attribute] = s3_url
    end
  end

  def fetch_content(uri)
    HTTP.get(uri)
  end

  def process_css(css_content, base_url)
    doc = Nokogiri::CSS::Stylesheet.parse(css_content)
    doc.css_rules.each do |rule|
      if rule.is_a?(Nokogiri::CSS::AtRule) && rule.name == 'font-face'
        rule.css_declarations.each do |declaration|
          if declaration.property == 'src'
            uri = URI.join(base_url, declaration.value)
            font_content = fetch_content(uri.to_s, base_url)
            s3_font_url = upload_to_s3(font_content, 'application/font-woff')
            declaration.value = "url(#{s3_font_url})"
          end
        end
      end
    end
    doc.to_css
  end
end
