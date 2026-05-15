class Captain::Llm::PdfProcessingService
  def initialize(document)
    @document = document
  end

  def process
    return if document.content.present?

    text = extract_pdf_text
    document.update!(content: text) if text.present?
  end

  private

  attr_reader :document

  def extract_pdf_text
    document.pdf_file.blob.open do |file|
      reader = PDF::Reader.new(file)
      reader.pages.map(&:text).join("\n\n")
    end
  rescue PDF::Reader::MalformedPDFError => e
    Rails.logger.error "PDF extraction failed for document #{document.id}: #{e.message}"
    nil
  rescue StandardError => e
    Rails.logger.error "PDF processing error for document #{document.id}: #{e.message}"
    nil
  end
end
