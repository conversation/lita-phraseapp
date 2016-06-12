require "lita/phraseapp"

describe Lita::Handlers::Phraseapp, lita_handler: true do
  let(:handler) { Lita::Handlers::Phraseapp.new(robot) }

  it "routes webhooks from phraseapp" do
    expect(handler).to route_http(:post, "/phraseapp").to(:phraseapp_event)
  end

end
