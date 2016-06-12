require 'lita/phraseapp_event'
require 'json'

describe PhraseappEvent do
  let(:uploads_processing_path) { File.join(File.dirname(__FILE__), "fixtures", "phraseapp_uploads_processing.json")}
  let(:uploads_processing_event) { PhraseappEvent.new(File.read(uploads_processing_path))}

  let(:uploads_create_path) { File.join(File.dirname(__FILE__), "fixtures", "phraseapp_uploads_create.json")}
  let(:uploads_create_event) { PhraseappEvent.new(File.read(uploads_create_path))}

  describe '.name' do
    describe 'with uploads:processing' do
      it "returns the name" do
        expect(uploads_processing_event.name).to eq("uploads:processing")
      end
    end
    describe 'with uploads:create' do
      it "returns the name" do
        expect(uploads_create_event.name).to eq("uploads:create")
      end
    end
  end

  describe '.message' do
    describe 'with uploads:processing' do
      it "returns the message" do
        expect(uploads_processing_event.message).to eq("foo initialized file upload en.yml in project bar\n")
      end
    end
    describe 'with uploads:create' do
      it "returns the message" do
        expect(uploads_create_event.message).to eq("foo uploaded file en.yml in project bar\n")
      end
    end
  end

  describe '.project_name' do
    describe 'with uploads:processing' do
      it "returns the project name" do
        expect(uploads_processing_event.project_name).to eq("bar")
      end
    end
    describe 'with uploads:create' do
      it "returns the project name" do
        expect(uploads_create_event.project_name).to eq("bar")
      end
    end
  end
end
