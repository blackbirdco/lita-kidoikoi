require "spec_helper"

describe Kidoikoi do
  let(:database) { double("database") }
  let(:kidoikoi) { Kidoikoi.new(database) }

  before do
    allow(database).to receive(:set)
    allow(database).to receive(:get)
  end

  describe "#split_bill_between" do
    subject { kidoikoi.split_bill_between(debtors, amount, creditor) }

    context "when there is no debt relation between users" do
      before do
        allow(database).to receive(:get).with("Loic").and_return(nil, {"Sacha" => 3})
      end

      context "when Sacha and Pg split a 9 euros bill with Loic" do
        let(:debtors) {["Sacha", "PG"]}
        let(:amount) {9}
        let(:creditor) {"Loic"}

        it "sets Sacha's and Pg's debt to Loic at 3 euros" do
          subject
          expect(database).to have_received(:set).with("Sacha", {"Loic" => -3})
          expect(database).to have_received(:set).with("PG", {"Loic" => -3})
          expect(database).to have_received(:set).with("Loic", {"Sacha" => 3, "PG" => 3})
        end
      end

      context "when Sacha is a debitor twice" do
        let(:debtors) {["Sacha", "Sacha", "PG"]}
        let(:amount) {9}
        let(:creditor) {"Loic"}

        it "counts Sacha as a debitor just once" do
          subject
          expect(database).to have_received(:set).with("Sacha", {"Loic" => -3})
          expect(database).to have_received(:set).with("PG", {"Loic" => -3})
          expect(database).to have_received(:set).with("Loic", {"Sacha" => 3, "PG" => 3})
        end
      end

      context "when Loic is the creditor and one debtor" do
        let(:debtors) {["Sacha", "PG", "Loic"]}
        let(:amount) {9}
        let(:creditor) {"Loic"}

        it "does not count Loic as a debtor" do
          subject
          expect(database).to have_received(:set).with("Sacha", {"Loic" => -3})
          expect(database).to have_received(:set).with("PG", {"Loic" => -3})
          expect(database).to have_received(:set).with("Loic", {"Sacha" => 3, "PG" => 3})
        end
      end
    end

    context "when a debt relation between users is already set" do
      before do
        allow(database).to receive(:get).with("Sacha").and_return({"Loic" => -50, "PG" => 5})
        allow(database).to receive(:get).with("Loic").and_return({"Sacha" => 50})
        allow(database).to receive(:get).with("PG").and_return({"Sacha" => -5})
      end

      context "when Sacha and Pg split a 23.50 euros bill with Loic" do
        let(:debtors) {["Sacha", "PG"]}
        let(:amount) {23.50}
        let(:creditor) {"Loic"}

        it "adds 7.83 to Sacha's and Pg's debt to Loic" do
          subject
          expect(database).to have_received(:set).with("Sacha", {"Loic" => -57.83, "PG" => 5})
          expect(database).to have_received(:set).with("PG", {"Loic" => -7.83, "Sacha" => -5})
          expect(database).to have_received(:set).with("Loic", {"Sacha" => 57.83, "PG" => 7.83}).at_least(1).times
        end
      end
    end
  end

  describe "#resume_debt" do
    context "when there is no debt relation between users" do
      it "returns an empty hash" do
        expect(kidoikoi.resume_debt("Loic")).to be_empty
      end
    end

    context "when a debt relation between users is already set" do
      before do
        allow(database).to receive(:get).with("Sacha").and_return({"Loic" => -50, "PG" => 5})
        allow(database).to receive(:get).with("Loic").and_return({"Sacha" => 50})
        allow(database).to receive(:get).with("PG").and_return({"Sacha" => -5})
      end

      it "returns a hash that resume debt relation of an user" do
        expect(kidoikoi.resume_debt("Loic")).to eq({"Sacha" => 50})
        expect(kidoikoi.resume_debt("Sacha")).to eq({"Loic" => -50, "PG" => 5})
        expect(kidoikoi.resume_debt("PG")).to eq({"Sacha" => -5})
      end
    end
  end

  describe "#clear_debt_between" do
    subject { kidoikoi.clear_debt_between(user1, user2) }

    let(:user1) { "Sacha" }
    let(:user2) { "Loic" }

    before do
      allow(database).to receive(:get).with("Sacha").and_return({"Loic" => 50})
      allow(database).to receive(:get).with("Loic").and_return({"Sacha" => -50, "PG"=> -50})
    end

    it "sets debt to zero between users" do
      subject
      expect(database).to have_received(:set).with("Sacha", {})
      expect(database).to have_received(:set).with("Loic", {"PG" => -50})
    end
  end
end
