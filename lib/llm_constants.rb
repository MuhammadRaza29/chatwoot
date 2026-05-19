# frozen_string_literal: true

module LlmConstants
  DEFAULT_MODEL = 'llama-3.3-70b-versatile'
  DEFAULT_EMBEDDING_MODEL = 'gemini-embedding-001'
  PDF_PROCESSING_MODEL = 'llama-3.3-70b-versatile'

  # Groq OpenAI-compatible endpoint (for chat/completion)
  OPENAI_API_ENDPOINT = 'https://api.groq.com/openai/v1'

  # Gemini OpenAI-compatible endpoint (for embeddings — Groq has no embedding API)
  EMBEDDING_API_ENDPOINT = 'https://generativelanguage.googleapis.com/v1beta/openai'

  PROVIDER_PREFIXES = {
    'openai' => %w[gpt- o1 o3 o4 text-embedding- whisper- tts-],
    'anthropic' => %w[claude-],
    'google' => %w[gemini-],
    'mistral' => %w[mistral- codestral-],
    'deepseek' => %w[deepseek-]
  }.freeze
end
