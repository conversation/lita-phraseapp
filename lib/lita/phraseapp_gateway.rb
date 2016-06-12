require 'phraseapp-ruby'
require 'ostruct'

class PhraseappGateway
  def initialize(api_key)
    @api_key = api_key
  end

  def project_name_to_id(name)
    projects_list, err = phraseapp_client.projects_list(1, 20)
    projects_list.select { |project|
      project.name.downcase == name.downcase
    }.map { |project|
      project.id
    }.first
  end

  def locales(project_id)
    locales_list, err = phraseapp_client.locales_list(project_id, 1, 20)
    locales = locales_list.flatten.map { |abbreviated_locale|
      phraseapp_client.locale_show(project_id, abbreviated_locale.id)
    }.flatten.compact.map { |locale|
      OpenStruct.new(
        name: locale.name,
        total: locale.statistics['keys_total_count'],
        completed: locale.statistics['translations_completed_count'],
        percent: (BigDecimal.new(locale.statistics['translations_completed_count'].to_f / locale.statistics['keys_total_count'], 5) * 100).round(2)
      )
    }
  end

  private

  def phraseapp_client
    @phraseapp_client ||= PhraseApp::Client.new(
      PhraseApp::Auth::Credentials.new(token: @api_key)
    )
  end
end
