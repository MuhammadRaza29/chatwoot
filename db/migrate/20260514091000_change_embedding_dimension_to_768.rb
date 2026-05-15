class ChangeEmbeddingDimensionTo768 < ActiveRecord::Migration[7.1]
  def up
    execute 'ALTER TABLE captain_assistant_responses DROP COLUMN IF EXISTS embedding'
    execute 'ALTER TABLE captain_assistant_responses ADD COLUMN embedding vector(768)'
    execute 'ALTER TABLE article_embeddings DROP COLUMN IF EXISTS embedding'
    execute 'ALTER TABLE article_embeddings ADD COLUMN embedding vector(768)'

    add_index :captain_assistant_responses, :embedding,
              using: :ivfflat,
              name: 'vector_idx_knowledge_entries_embedding',
              opclass: :vector_l2_ops
  end

  def down
    remove_index :captain_assistant_responses, name: 'vector_idx_knowledge_entries_embedding', if_exists: true

    execute 'ALTER TABLE captain_assistant_responses DROP COLUMN IF EXISTS embedding'
    execute 'ALTER TABLE captain_assistant_responses ADD COLUMN embedding vector(1536)'
    execute 'ALTER TABLE article_embeddings DROP COLUMN IF EXISTS embedding'
    execute 'ALTER TABLE article_embeddings ADD COLUMN embedding vector(1536)'
  end
end
