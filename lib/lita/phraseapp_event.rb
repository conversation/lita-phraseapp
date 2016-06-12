require 'json'

# Value object that wraps raw phraseapp webhook data and provides convenience
# methods for querying it
class PhraseappEvent
  attr_reader :data

  def initialize(data)
    @data = JSON.load(data)
  end

  def name
    @data.fetch("event")
  end

  def message
    @data.fetch("message")
  end

  def project_name
    @data.fetch("project", {}).fetch("name", nil)
  end

end
