class Api::V1::HtmlDocumentsController < Api::ApiController
  # before_action :authenticate_user!
  before_action :build_document, only: [:create]
  before_action :find_document, only: [:show]

  def create
    if @html_document.save
      doc_id = @html_document.id
      ProcessHtmlDocumentJob.perform_later(doc_id)
      render_ok(data: { id: doc_id })
    else
      render_unprocessable_entity(@html_document.errors.join(', '))
    end
  end

  def show
    render_ok(data: { content: @html_document.content, processed_status: @html_document.processed_status })
  end

  # private

  def document_params
    params.permit(:id, :content)
  end

  def build_document
    @html_document = HtmlDocument.new(content: document_params[:content])
  end

  def find_document
    @html_document = HtmlDocument.find(document_params[:id])
  end
end
