class Captain::Llm::FaqGeneratorService < Llm::BaseAiService
  include Integrations::LlmInstrumentation

  # Lower temperature for structured JSON output — high values cause schema drift
  FAQ_TEMPERATURE = 0.3

  def initialize(content, language = 'english', account_id: nil)
    super()
    @language = language
    @content = content
    @account_id = account_id
    @temperature = FAQ_TEMPERATURE
  end

  def generate
    response = instrument_llm_call(instrumentation_params) do
      chat
        .with_params(response_format: { type: 'json_object' })
        .with_instructions(system_prompt)
        .ask(user_prompt)
    end

    parse_response(response.content)
  rescue RubyLLM::Error => e
    Rails.logger.error "LLM API Error: #{e.message}"
    []
  end

  private

  attr_reader :content, :language

  def system_prompt
    Captain::Llm::SystemPromptsService.faq_generator(language)
  end

  def user_prompt
    <<~PROMPT
      #{@content}

      REQUIRED OUTPUT FORMAT — respond with ONLY this JSON structure, no other keys:
      {"faqs": [{"question": "...", "answer": "..."}, ...]}
    PROMPT
  end

  def instrumentation_params
    {
      span_name: 'llm.captain.faq_generator',
      model: @model,
      temperature: @temperature,
      feature_name: 'faq_generator',
      account_id: @account_id,
      messages: [
        { role: 'system', content: system_prompt },
        { role: 'user', content: @content }
      ]
    }
  end

  def parse_response(content)
    return [] if content.nil?

    JSON.parse(sanitize_json_response(content)).fetch('faqs', [])
  rescue JSON::ParserError => e
    Rails.logger.error "Error in parsing GPT processed response: #{e.message}"
    []
  end
end
