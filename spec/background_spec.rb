require "spec_helper"

class DummyClass
  include PaperTrail::Background

  def initialize(options: {}, record: nil)
    @options = options
    @record = record
  end

  def enabled?
    @options[:enabled]
  end

  def data_for_create
    {}
  end

  def data_for_destroy
    {}
  end

  def data_for_update_columns
    {}
  end

  def force
    true
  end
end

class VersionJob
  def self.perform_later(*args); end
end

RSpec.describe PaperTrail::Background do
  before do
    allow(VersionJob).to receive(:perform_later)
  end

  describe "#record_create" do
    it "does not trigger a write if not enabled" do
      DummyClass.new(options: { enabled: false }).record_create

      expect(VersionJob).not_to have_received(:perform_later)
    end

    context "when enabled and opt_in config is enabled" do
      let(:record) { double("SomeRecord") }

      before do
        PaperTrail::Background::Config.configure do |config|
          config.opt_in = true
        end
      end

      it "does not trigger a write if record is opted in but async is blank" do
        allow(record).to receive(:paper_trail_options).and_return(async: nil)

        DummyClass.new(options: { enabled: true }, record: record).record_create

        expect(VersionJob).not_to have_received(:perform_later)
      end

      it "triggers a write if record is opted in and async is true" do
        allow(record).to receive(:paper_trail_options).and_return(async: true)
        allow(PaperTrail::Events::Create).to receive(:new).and_return(OpenStruct.new(data: {}))
        allow(RSpec::Mocks::Double).to receive(:paper_trail).and_return(OpenStruct.new(version_class: Class))
        allow(ActiveRecord::Base).to receive(:after_transaction).and_yield

        DummyClass.new(options: { enabled: true }, record: record).record_create

        expect(VersionJob).to have_received(:perform_later)
      end
    end
  end

  describe "#record_destroy" do
    it "does not trigger a write if not enabled" do
      DummyClass.new(options: { enabled: false }).record_destroy("after")

      expect(VersionJob).not_to have_received(:perform_later)
    end

    context "when enabled and opt_in config is enabled" do
      let(:record) { double("SomeRecord") }

      before do
        PaperTrail::Background::Config.configure do |config|
          config.opt_in = true
        end
      end

      it "does not trigger a write if record is opted in but async is blank" do
        allow(record).to receive(:paper_trail_options).and_return(async: nil)

        DummyClass.new(options: { enabled: true }, record: record).record_destroy("after")

        expect(VersionJob).not_to have_received(:perform_later)
      end

      it "does not trigger a write if record is new" do
        allow(record).to receive(:paper_trail_options).and_return(async: true)
        allow(record).to receive(:new_record?).and_return(true)

        DummyClass.new(options: { enabled: true }, record: record).record_destroy("after")

        expect(VersionJob).not_to have_received(:perform_later)
      end

      it "triggers a write if record is opted in and async is true" do
        allow(record).to receive(:paper_trail_options).and_return(async: true)
        allow(record).to receive(:new_record?).and_return(false)
        allow(PaperTrail::Events::Destroy).to receive(:new).and_return(OpenStruct.new(data: {}))
        allow(RSpec::Mocks::Double).to receive(:paper_trail).and_return(OpenStruct.new(version_class: Class))
        allow(ActiveRecord::Base).to receive(:after_transaction).and_yield

        DummyClass.new(options: { enabled: true }, record: record).record_destroy("after")

        expect(VersionJob).to have_received(:perform_later)
      end
    end
  end

  describe "#record_update" do
    it "does not trigger a write if not enabled" do
      DummyClass.new(options: { enabled: false }).record_update(force: true, in_after_callback: true, is_touch: false)

      expect(VersionJob).not_to have_received(:perform_later)
    end

    context "when enabled and opt_in config is enabled" do
      let(:record) { double("SomeRecord") }

      before do
        PaperTrail::Background::Config.configure do |config|
          config.opt_in = true
        end
      end

      it "does not trigger a write if record is opted in but async is blank" do
        allow(record).to receive(:paper_trail_options).and_return(async: nil)

        DummyClass.new(options: { enabled: true }, record: record).record_update(force: true, in_after_callback: true, is_touch: false)

        expect(VersionJob).not_to have_received(:perform_later)
      end

      it "triggers a write if record is opted in and async is true" do
        allow(record).to receive(:paper_trail_options).and_return(async: true)
        allow(record).to receive(:new_record?).and_return(false)
        allow(PaperTrail::Events::Update).to receive(:new).and_return(OpenStruct.new(data: {}))
        allow(RSpec::Mocks::Double).to receive(:paper_trail).and_return(OpenStruct.new(version_class: Class))
        allow(ActiveRecord::Base).to receive(:after_transaction).and_yield

        DummyClass.new(options: { enabled: true }, record: record).record_update(force: true, in_after_callback: true, is_touch: false)

        expect(VersionJob).to have_received(:perform_later)
      end
    end
  end

  describe "#record_update_columns" do
    it "does not trigger a write if not enabled" do
      DummyClass.new(options: { enabled: false }).record_update_columns({})

      expect(VersionJob).not_to have_received(:perform_later)
    end

    context "when enabled and opt_in config is enabled" do
      let(:record) { double("SomeRecord") }

      before do
        PaperTrail::Background::Config.configure do |config|
          config.opt_in = true
        end
      end

      it "does not trigger a write if record is opted in but async is blank" do
        allow(record).to receive(:paper_trail_options).and_return(async: nil)

        DummyClass.new(options: { enabled: true }, record: record).record_update_columns({})

        expect(VersionJob).not_to have_received(:perform_later)
      end

      it "triggers a write if record is opted in and async is true" do
        allow(record).to receive(:paper_trail_options).and_return(async: true)
        allow(record).to receive(:new_record?).and_return(false)
        allow(PaperTrail::Events::Update).to receive(:new).and_return(OpenStruct.new(data: {}))
        allow(RSpec::Mocks::Double).to receive(:paper_trail).and_return(OpenStruct.new(version_class: Class))
        allow(ActiveRecord::Base).to receive(:after_transaction).and_yield

        DummyClass.new(options: { enabled: true }, record: record).record_update_columns({})

        expect(VersionJob).to have_received(:perform_later)
      end
    end
  end
end
