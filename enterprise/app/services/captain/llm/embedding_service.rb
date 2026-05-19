class Captain::Llm::EmbeddingService
  include Integrations::LlmInstrumentation

  class EmbeddingsError < StandardError; end

  EMBEDDING_DIMENSIONS = 768

  def initialize(account_id: nil)
    Llm::Config.initialize!
    @account_id = account_id
    @embedding_model = InstallationConfig.find_by(name: 'CAPTAIN_EMBEDDING_MODEL')&.value.presence || LlmConstants::DEFAULT_EMBEDDING_MODEL
  end

  def self.embedding_model
    InstallationConfig.find_by(name: 'CAPTAIN_EMBEDDING_MODEL')&.value.presence || LlmConstants::DEFAULT_EMBEDDING_MODEL
  end

  def get_embedding(content, model: @embedding_model)
    return [] if content.blank?

    instrument_embedding_call(instrumentation_params(content, model)) do
      fetch_embedding(content, model)
    end
  rescue EmbeddingsError
    raise
  rescue StandardError => e
    Rails.logger.error "Embedding API Error: #{e.message}"
    raise EmbeddingsError, "Failed to create an embedding: #{e.message}"
  end

  private

  def fetch_embedding(content, model)
    api_key = InstallationConfig.find_by(name: 'CAPTAIN_EMBEDDING_API_KEY')&.value.presence ||
              InstallationConfig.find_by(name: 'CAPTAIN_OPEN_AI_API_KEY')&.value
    endpoint = InstallationConfig.find_by(name: 'CAPTAIN_EMBEDDING_ENDPOINT')&.value.presence ||
               LlmConstants::EMBEDDING_API_ENDPOINT

    uri = URI("#{endpoint.chomp('/')}/embeddings")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    http.open_timeout = 30
    http.read_timeout = 60

    request = Net::HTTP::Post.new(uri.path, {
                                    'Authorization' => "Bearer #{api_key}",
                                    'Content-Type' => 'application/json'
                                  })
    request.body = { model: model, input: content, dimensions: EMBEDDING_DIMENSIONS }.to_json

    response = http.request(request)
    body = JSON.parse(response.body)

    raise EmbeddingsError, "Embedding API error (#{response.code}): #{body.dig('error', 'message') || response.body}" unless response.is_a?(Net::HTTPSuccess)

    body.dig('data', 0, 'embedding') || raise(EmbeddingsError, "No embedding returned: #{response.body}")
  end

  def instrumentation_params(content, model)
    {
      span_name: 'llm.captain.embedding',
      model: model,
      input: content,
      feature_name: 'embedding',
      account_id: @account_id
    }
  end
end
